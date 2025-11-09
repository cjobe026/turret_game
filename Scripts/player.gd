extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var human = $MeshInstance3D/human_godot
@onready var anim_tree: AnimationTree = human.get_node("AnimationTree")

func _ready():
	anim_tree.active = true

func _physics_process(delta: float) -> void:
	# some gravitas 
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Input for bitches
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
#direction.length will return input strength - 0 for no presses
	if direction.length() > 0.1:
		direction = direction.normalized()
		
		# makes vector have a length of 1 - so we get direction - fuck the magnitude screw diagonals
		# world direction
		var move_dir = (global_transform.basis * direction).normalized()

		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED

		# calc rotation based on movement along ground also need negative because forward is -z - so we need to invert for character local -z
		var target_rot_y = atan2(-move_dir.x, -move_dir.z)
		#smooth rotates toward target_rot_y, (from, to, weight)
		human.rotation.y = lerp_angle(human.rotation.y, target_rot_y, delta * 10.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#classic move and slide shit
	move_and_slide()
	# animation movement calc - geting magnitude 
	var move_speed = Vector2(velocity.x, velocity.z).length()
	var blend_amount = clamp(move_speed / SPEED, 0.0, 1.0)



	anim_tree.set("parameters/Blend2/blend_amount", blend_amount)
	anim_tree.set("parameters/TimeScale/scale", 0.8 + blend_amount * 1.2)
