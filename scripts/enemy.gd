extends CharacterBody3D

# TODO
# add random strafes
#fix knockback code so zero velocity doesnt cancel
#improve cps variance
# prevent enemies from falling over the edge (add center of map as lower influence vector?)

var target
var aim_direction
var movement_direction
var air_accel = 30
var speed = 3
var invincible = false
var random = randi_range(-1, 1)
var cps_multiplier = randf_range(2,3)
var vertical_vector = Vector3(0,1,0) #used for cross product

signal hit_opponent

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if target:
		if target.global_position.y > 0: #if above sumo floor
			aim_direction = (target.global_position - self.global_position).normalized()
			#add strafes to movement
			movement_direction = (random * aim_direction.cross(vertical_vector) + aim_direction).normalized()
			if not is_on_floor(): #slower acceleration in the air
				velocity.x = move_toward(velocity.x, movement_direction.x * speed, speed/air_accel)
				velocity.z = move_toward(velocity.z, movement_direction.z * speed, speed/air_accel)
			else:
				velocity.x = move_toward(velocity.x, movement_direction.x * speed, speed)
				velocity.z = move_toward(velocity.z, movement_direction.z * speed, speed)
		elif target.global_position.y < 0: #celebration if enemy is below sumo floor
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, speed)
				velocity.z = move_toward(velocity.z, 0, speed)
				velocity.y = 4.5
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
				velocity.z = move_toward(velocity.z, 0, speed)	
			
		#position ray + change length of raycast to simulate variance in cps
		$RayCast3D.target_position = (aim_direction*cps_multiplier) 

	#check if opponent is hit
	if $RayCast3D.is_colliding() == true:	
		if $RayCast3D.get_collider().is_in_group("character"):
			hit_opponent.emit()
		else:
			pass	
		
	move_and_slide()


#lock onto target & receive hit signals
func _on_area_3d_area_entered(area: Area3D) -> void:
	target = area.get_parent()
	target.hit_opponent.connect(self.got_hit)
	print(target)

#switch off enemy once out of range
func _on_area_3d_area_exited(area: Area3D) -> void:
	if area == target:
		target = null

func got_hit():
	if invincible == false:
		#change to be in direction of hit, currently allows you to negate kb if standing still
		print(aim_direction.x)
		velocity.x = velocity.x + aim_direction.x * -10
		velocity.z = velocity.z + aim_direction.z * -10
		velocity.y = velocity.y + 3
		invincible = true
		$InvincibilityTimer.start()
	elif invincible == true:
		pass #ignore hit

func _on_invincibility_timer_timeout() -> void:
	invincible = false

#vary the amount of time the bot strafes
func _on_movement_timer_timeout() -> void: 
	$MovementTimer.wait_time = randi_range(1,3)
	random = randi_range(-1, 1)

func _on_cps_timer_timeout() -> void:
	$CPSTimer.wait_time = randi_range(1,3)
	cps_multiplier = randf_range(2,3)
	
