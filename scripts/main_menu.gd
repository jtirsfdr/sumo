#main menu: main menu
extends Control

func _ready():
	var viewport_rect = get_viewport_rect().size
	self.position = Vector2(viewport_rect.x/2, viewport_rect.y/2)
