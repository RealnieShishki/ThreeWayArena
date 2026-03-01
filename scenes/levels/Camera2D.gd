extends Camera2D

func _process(_delta: float) -> void:
	var player = get_node_or_null("../Player")
	if player:
		position = player.position
