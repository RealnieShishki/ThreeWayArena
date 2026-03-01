extends CharacterBody2D

@export var speed: float = 180.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5
@export var attack_range: float = 150.0

var _can_attack: bool = true
var _facing_direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = $Visual

func _ready() -> void:
	print("🎮 Player Ready")

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * speed
		_facing_direction = input_dir.normalized()
		if _facing_direction.x < 0:
			sprite.flip_h = true
		elif _facing_direction.x > 0:
			sprite.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 0.8)
	
	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _can_attack:
		_attack()
		
	# 📷 Камера следует за игроком
	var camera = get_node_or_null("../../Camera2D")
	if camera:
		camera.global_position = global_position

func _attack() -> void:
	_can_attack = false
	print("⚔️ Attack!")
	
	var targets = get_tree().get_nodes_in_group("enemy")
	
	for target in targets:
		var dist = global_position.distance_to(target.global_position)
		if dist < attack_range:
			print("🎯 HIT! Enemy: %s" % target.name)
			
			# ✨ Эффект в позиции врага
			_spawn_hit_effect(target.global_position)
			
			if target.has_method("take_damage"):
				target.take_damage(attack_damage)
			break
	
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

func _spawn_hit_effect(pos: Vector2) -> void:
	var effect_scene = load("res://scenes/effects/HitEffect.tscn")
	if effect_scene == null:
		return
	var effect = effect_scene.instantiate()
	effect.global_position = pos
	
	# 🔍 В КОРЕНЬ СЦЕНЫ!
	get_tree().current_scene.add_child(effect)

func take_damage(amount: int) -> void:
	print("💥 Player hurt! Damage: %d" % amount)

func die() -> void:
	print("☠️ Player died")
	queue_free()
