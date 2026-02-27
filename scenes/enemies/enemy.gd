extends CharacterBody2D

# === НАСТРОЙКИ ===
@export var health: int = 30
@export var speed: float = 60.0
@export var damage: int = 5

# === ВНУТРЕННИЕ ПЕРЕМЕННЫЕ ===
var _is_alive: bool = true
var _player: Node2D = null

@onready var sprite: Sprite2D = $Visual

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if not _is_alive:
		return
	
	# Простой ИИ: если игрок рядом — двигаться к нему
	if _player:
		var direction = (_player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Поворот спрайта к игроку
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 0.8)
	
	move_and_slide()

# === ПУБЛИЧНЫЕ МЕТОДЫ ===
func take_damage(amount: int) -> void:
	if not _is_alive:
		return
	
	health -= amount
	print("👾 Enemy hit! HP: %d/%d" % [health, 30])
	
	# Визуальный фидбек (мигание)
	$Visual.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Visual.modulate = Color.GREEN
	
	if health <= 0:
		die()

func die() -> void:
	_is_alive = false
	print("☠️ Enemy died!")
	queue_free()

# === ОБНАРУЖЕНИЕ ИГРОКА (через Area2D) ===
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_player = body
		print("👁️ Enemy sees Player!")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		_player = null
