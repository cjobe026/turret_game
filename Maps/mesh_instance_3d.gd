extends MeshInstance3D

var current_speed: float = 0.0
@export var target_speed: float = 2.0
@export var acceleration: float = 1.0

func _process(delta: float) -> void:
	current_speed = lerp(current_speed, target_speed, delta * acceleration)
	rotation.y += current_speed * delta
