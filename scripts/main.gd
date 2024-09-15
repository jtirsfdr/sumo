#main: handles initialization
extends Node3D

@export var menu_manager_tscn: PackedScene
@export var world_tscn: PackedScene

func _ready():
	initialize_game()
	
func initialize_game():
	var world_node = world_tscn.instantiate()
	add_child(world_node)
	var menu_manager_node = menu_manager_tscn.instantiate()
	add_child(menu_manager_node)
		
		
