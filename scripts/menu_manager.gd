#menu manager: switch between menus
extends Control

@onready var world_node = get_node("../World")

func _ready():
	hide_menus()
	$MainMenu.visible = true

#func _process(delta): #show pause menu only when game is started
	#if Input.is_action_just_pressed("pause"):
		#if main_node.is_game_started:
			#if main_node.is_game_paused:
				#main_node.is_game_paused = false
				#_on_play_button_pressed()
			#elif main_node.is_game_paused == false:
				#main_node.is_game_paused= true
				#init_pause_menu()

func init_main_menu():
	hide_menus()
	$MainMenu.visible = true
	
func init_pause_menu():
	hide_menus()
	$PauseMenu.visible = true

func hide_menus():
	$MainMenu.visible = false
	$OptionsMenu.visible = false
	$PauseMenu.visible = false

func _on_main_menu_button_pressed() -> void:
	hide_menus()
	$MainMenu.visible = true

func _on_options_button_pressed() -> void:
	hide_menus()
	$OptionsMenu.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	print("MenuManager on_play_pressed")
	hide_menus()
	world_node.start_game()
	

	
