#handles game state
extends Node3D

signal on_world_game_started
signal on_world_game_ended

@onready var menu_node = get_node("../MenuManager")

var is_game_started = true
var is_game_paused

func _ready():
	start_demo()

func start_demo():
	#print("World start_demo")
	$PlayerSpawner.on_character_death.connect(self.character_died)
	$DemoCamera.make_current()
	$PlayerSpawner.spawn_two_enemies()
	var is_game_started = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_game():
	print("World start_game")
	$PlayerSpawner.clear_players()
	$PlayerSpawner.spawn_player_and_enemy()
	on_world_game_started.emit()
	var is_game_started = true
	
func end_game():
	print("World end_game")
	#play results screen and then
	get_node("../MenuManager").init_main_menu()
	start_demo()

func pause_game():
	#free mouse, stop player movement, stop bot movement
	pass

func unpause_game():
	#lock mouse, allow player to move, start bot movement
	pass
	
func character_died():
	#print("World character_died")
	if is_game_started == false:
		start_demo()
	elif is_game_started == true:
		end_game()
