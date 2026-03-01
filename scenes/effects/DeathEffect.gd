extends GPUParticles2D

func _ready() -> void:
	print("💥 DeathEffect._ready() called")
	
	amount = 80
	lifetime = 1.5
	emitting = true
	one_shot = true
	scale = Vector2(5, 5)
	
	texture = preload("res://icon.svg")
	
	var mat = ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
	mat.direction = Vector3(0, 0, 0)
	mat.spread = 360.0
	mat.scale_min = 0.5
	mat.scale_max = 1.5
	mat.color = Color(0.8, 0.2, 1.0, 1.0)
	
	process_material = mat
	
	finished.connect(queue_free)
