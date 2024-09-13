extends CharacterBody3D

var target
var direction
var speed = 3
var invincible = false

signal hit_opponent

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if target:
		direction = (target.global_position - self.global_position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		#position + change length of raycast to simulate variance in cps
		$RayCast3D.target_position = (direction*randf_range(2,3)) 
		
	if $RayCast3D.is_colliding() == true:	
		#print($RayCast3D.get_collider())
		hit_opponent.emit()
		
	move_and_slide()


#lock onto target & receive hit signals
func _on_area_3d_area_entered(area: Area3D) -> void:
	target = area.get_parent()
	target.hit_opponent.connect(self.got_hit)
	print(target)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area == target:
		target = null

func got_hit():
	if invincible == false:
		print("got hit")
		invincible = true
		$InvincibilityTimer.start()
		#take knockback
	elif invincible == true:
		pass #ignore hit

func _on_invincibility_timer_timeout() -> void:
	invincible = false
