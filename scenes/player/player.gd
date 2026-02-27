extends CharacterBody2D

# === НАСТРОЙКИ ===
@export var speed: float = 180.0
@export var health: int = 100
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5
@export var attack_range: float = 60.0

# === ВНУТРЕННИЕ ПЕРЕМЕННЫЕ ===
var _can_attack: bool = true
var _facing_direction: Vector2 = Vector2.RIGHT

# Ссылки на узлы
@onready var sprite: Sprite2D = $Visual
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	print("🎮 Player ready! Position: %s" % global_position)
	print("   Health: %d, Speed: %f" % [health, speed])
	
	# Проверка спрайта
	if sprite and not sprite.texture:
		push_warning("⚠️ Sprite has no texture! Assign icon.svg")

func _physics_process(_delta: float) -> void:
	# 1. Ввод движения
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Движение
	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * speed
		_facing_direction = input_dir.normalized()
		_update_facing_visual()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 0.8)
	
	move_and_slide()
	
	# 3. Атака
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _can_attack:
		_attack()

func _update_facing_visual() -> void:
	if sprite:
		if _facing_direction.x < 0:
			sprite.flip_h = true
		elif _facing_direction.x > 0:
			sprite.flip_h = false

func _attack() -> void:
	_can_attack = false
	
	print("⚔️ Attack! Damage: %d" % attack_damage)
	
	# Raycast для попадания
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	var query = PhysicsRayQueryParameters2D.create(global_position, mouse_pos)
	query.collide_with_areas = true
	query.collision_mask = 2  # Слой "Enemy"
	
	var result = space_state.intersect_ray(query)
	if result and result.collider:
		var target = result.collider
		if target.has_method("take_damage"):
			target.take_damage(attack_damage)
			print("🎯 Hit: %s" % target.name)
	
	# Кулдаун
	await get_tree().create_timer(attack_cooldown).timeout
	_can_attack = true

# === ПУБЛИЧНЫЕ МЕТОДЫ ===
func take_damage(amount: int) -> void:
	health -= amount
	print("💥 Player hit! HP: %d/%d" % [health, 100])
	if health <= 0:
		die()

func die() -> void:
	print("☠️ Player died")
	queue_free()

func heal(amount: int) -> void:
	health = min(health + amount, 100)
