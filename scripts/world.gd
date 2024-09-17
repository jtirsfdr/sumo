#handles game state
extends Node3D

signal on_world_game_started
signal on_world_game_ended

@onready var menu_node = get_node("../MenuManager")

var is_game_started = true
var is_game_paused
var death

func _ready():
	start_demo()

func start_demo():
	print("World start_demo")
	$PlayerSpawner.on_character_death.connect(self.entity_died)
	$PlayerSpawner.on_game_end.connect(self.end_game)
	$DemoCamera.make_current()
	$PlayerSpawner.spawn_two_enemies()
	is_game_started = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_game():
	print("World start_game")
	$PlayerSpawner.clear_players()
	$PlayerSpawner.spawn_player_and_enemy()
	on_world_game_started.emit()
	is_game_started = true
	
func end_game():
	print("World end_game")
	if is_game_started == true:
		is_game_started = false
		$GameEndTimer.start()
		if death == "player":
			$LoseScreen.visible = true
		if death == "enemy":
			$WinScreen.visible = true
			print("enemy death")
			for n in $WinParticles.get_children():
				n.emitting = true
				n.visible = true
	else:
		$PlayerSpawner.clear_players()
		start_demo()


func pause_game():
	#free mouse, stop player movement, stop bot movement
	pass

func unpause_game():
	#lock mouse, allow player to move, start bot movement
	pass
	
func entity_died():
	pass
	##print("World character_died")
	#if is_game_started == false:
		#start_demo()
	#elif is_game_started == true:
		#end_game()


func _on_game_end_timer_timeout() -> void:
	print("timeout")
	for n in $WinParticles.get_children():
		n.emitting = false
		n.visible = false
	$WinScreen.visible = false
	$LoseScreen.visible = false
	get_node("../MenuManager").init_main_menu()
	start_demo()
