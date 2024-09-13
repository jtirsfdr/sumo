#menu manager: stupid scene i have to make to avoid circular dependencies
extends Control

var pause_toggled = false

signal on_menu_manager_game_paused
signal on_menu_manager_game_unpaused

func _ready():
	init_main_menu()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if pause_toggled == true:
			pause_toggled = false
			_on_play_button_pressed()
		elif pause_toggled == false:
			pause_toggled = true
			init_pause_menu()


func init_main_menu():
	hide_menus()
	$MainMenu.visible = true
	
func init_options_menu():
	hide_menus()
	$OptionsMenu.visible = true
	
func init_pause_menu():
	hide_menus()
	$PauseMenu.visible = true
	on_menu_manager_game_paused.emit()

func hide_menus():
	$MainMenu.visible = false
	$OptionsMenu.visible = false
	$PauseMenu.visible = false
	
func _on_main_menu_button_pressed() -> void:
	init_main_menu()

func _on_options_button_pressed() -> void:
	init_options_menu()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	pause_toggled = false
	hide_menus()
	on_menu_manager_game_unpaused.emit()
