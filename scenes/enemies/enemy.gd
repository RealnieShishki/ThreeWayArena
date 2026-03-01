extends CharacterBody2D  # Важно: CharacterBody2D, а не Area2D

@export var health: int = 30
@export var speed: float = 60.0

var _is_alive: bool = true
var _player: Node2D = null

@onready var sprite: Sprite2D = $Visual

func _physics_process(_delta: float) -> void:
	if not _is_alive: return
	
	# Простой поиск игрока (по имени узла, как было раньше)
	if not _player:
		_player = get_node_or_null("../../Player")
	
	if _player:
		var dir = (_player.global_position - global_position).normalized()
		velocity = dir * speed
		if dir.x < 0: sprite.flip_h = true
		elif dir.x > 0: sprite.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 0.8)
	
	move_and_slide()

func take_damage(amount: int) -> void:
	if not _is_alive: return
	health -= amount
	print("👾 Enemy HP: %d" % health)
	
	# Мигание красным
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	
	if health <= 0:
		die()

func die() -> void:
	_is_alive = false
	print("☠️ Enemy Died!")
	
	# ✨ Спавн эффекта смерти
	_spawn_death_effect()
	
	queue_free()

func _spawn_death_effect() -> void:
	var effect_scene = load("res://scenes/effects/DeathEffect.tscn")
	if effect_scene == null:
		return
	var effect = effect_scene.instantiate()
	effect.global_position = global_position
	
	# 🔍 ДОБАВЛЯЕМ В КОРЕНЬ СЦЕНЫ, не в Enemy!
	get_tree().current_scene.add_child(effect)
