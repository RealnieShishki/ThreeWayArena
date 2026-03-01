extends GPUParticles2D

func _ready() -> void:
	print("🎆 HitEffect._ready() called")
	print("   Position: %s" % global_position)
	
	# Настройки частиц
	amount = 50
	lifetime = 1.0
	emitting = true
	one_shot = true
	scale = Vector2(3, 3)
	
	# Текстура на УЗЕЛ (не на материал!)
	texture = preload("res://icon.svg")
	
	# Материал
	var mat = ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
	
	# Скорость (в Godot 4 это свойство материала)
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 180.0
	
	# Размер частиц
	mat.scale_min = 0.5
	mat.scale_max = 1.0
	
	# Цвет
	mat.color = Color(1.0, 0.5, 0.0, 1.0)
	
	process_material = mat
	
	finished.connect(queue_free)
