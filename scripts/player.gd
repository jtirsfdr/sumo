extends CharacterBody3D

var enemy_node
@onready var camera = $Camera3D

const SPEED = 3
const JUMP_VELOCITY = 4.5
var air_accel = 30
var invincible = false
var target
var already_dead = false
signal hit_opponent
var sensitivity
var knockback = 10
func _ready():
	camera.make_current()
	if get_node("../../../").find_child("KnockbackOption", true, false).text:
		sensitivity = float(get_node("../../../").find_child("SensitivityOption", true, false).text)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * sensitivity/500) #replace magic num with sensitivity
		camera.rotate_x(-event.relative.y * sensitivity/500)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		$RayCast3D.target_position = -camera.transform.basis.z * 3 # replace magic number with range

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if not is_on_floor(): #slower acceleration in the air
			velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED/air_accel)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, SPEED/air_accel)
		else:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/air_accel)
		velocity.z = move_toward(velocity.z, 0, SPEED/air_accel)
	
	if Input.is_action_just_pressed("attack"):
		if $RayCast3D.is_colliding():
			if $RayCast3D.get_collider().is_in_group("entity"):
				hit_opponent.emit()
	
	if position.y < -70:
		if already_dead == false:
			print("player dead")
			get_node("../..").death = "player"
			get_node("..").entity_death()
			already_dead = true	
			
	move_and_slide()
	
func got_hit():
	print("PLAYTER HIT")
	if invincible == false:
		if get_node("../../../").find_child("KnockbackOption", true, false).text:
			knockback = int(get_node("../../../").find_child("KnockbackOption", true, false).text)
		print(knockback)
		var aim_direction = (target.global_position - self.global_position).normalized()
		velocity.x = velocity.x  * aim_direction.x * -knockback/2
		velocity.z = velocity.z  * aim_direction.z * -knockback/2
		velocity.y = velocity.y + 3
		invincible = true
		$InvincibilityTimer.start()
	elif invincible == true:
		pass #ignore hit


func _on_range_area_entered(area: Area3D) -> void:
	target = area.get_parent()
	target.hit_opponent.connect(self.got_hit)


func _on_invincibility_timer_timeout() -> void:
	invincible = false
