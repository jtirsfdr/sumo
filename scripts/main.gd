#main: handles initialization and game state (for now)
extends Node3D

@export var menu_manager_tscn: PackedScene
@export var world_tscn: PackedScene

var is_game_started = false

signal game_paused
signal game_unpaused
signal game_started
signal game_ended

func _ready():
	initialize_game()
	
func initialize_game():
	var world_node = world_tscn.instantiate()
	add_child(world_node)
	var menu_manager_node = menu_manager_tscn.instantiate()
	add_child(menu_manager_node)
	menu_manager_node.on_menu_manager_game_paused.connect(self.pause_game)
	menu_manager_node.on_menu_manager_game_unpaused.connect(self.unpause_game)

func pause_game():
	print("game paused")
	game_paused.emit()
	
func unpause_game():
	print("game unpaused")
	if is_game_started == false:
		start_game()
	elif is_game_started == true:
		game_unpaused.emit()
		
		
func start_game():
	is_game_started = true
	game_started.emit()
	print("game started")
