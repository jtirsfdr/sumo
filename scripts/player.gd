extends CharacterBody3D

var enemy_node
@onready var camera = $Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

signal hit

func _ready():
	pass
	#camera.make_current()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
	#	self.rotate_y(-event.relative.x * 0.005) #replace magic num with sensitivity
	#	camera.rotate_x(-event.relative.y * 0.005)
	#	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	#	$RayCast3D.target_position = -camera.transform.basis.z * 3 # replace magic number with range

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("attack"):
		if $RayCast3D.is_colliding():
			print("hit")
			
	move_and_slide()
