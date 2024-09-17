#spawns and removes players
extends Node3D

@export var player_tscn: PackedScene
@export var enemy_tscn: PackedScene

signal on_character_death
signal on_game_end

func spawn_two_enemies():
	#print("PlayerSpawner spawn_two_enemies")
	var e1 = enemy_tscn.instantiate()
	e1.mesh_color1 = Color(.3, .8, .3, 1)
	e1.position = Vector3(-10,10,7.5)
	add_child(e1)
	var e2 = enemy_tscn.instantiate()
	e2.mesh_color2 = Color(.8, .3, .3, 1)
	e2.position = Vector3(10,10,7.5)
	add_child(e2)

	
func spawn_player_and_enemy():
	#print("PlayerSpawner spawn_player_and_enemy")
	var p1 = player_tscn.instantiate()
	p1.position = Vector3(-10,10,0)
	add_child(p1)
	var e3 = enemy_tscn.instantiate()
	e3.mesh_color2 = Color(.8, .3, .3, 1)
	e3.position = Vector3(10,10,0)
	add_child(e3)


func clear_players():
	print("PlayerSpawner clear_players")
	for n in self.get_children():
		if n.is_in_group("entity"):
			self.remove_child(n)

func entity_death():
	#print("PlayerSpawner character_death")
	if get_node("..").is_game_started == true:	
		$DespawnTimer.start()
		on_game_end.emit()
	else:
		on_game_end.emit()


func _on_despawn_timer_timeout() -> void:
	print("despawn timer timeout")
	clear_players()
	on_character_death.emit()
