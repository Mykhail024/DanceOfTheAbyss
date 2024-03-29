extends CanvasLayer

@export_category("World")
@export var world : World

func _ready():
	world.connect("pause_toggled", _on_toggled_game_paused)

func _main_menu() -> void:
	world.game_paused = false
	get_tree().change_scene_to_file("res://src/MainMenu/main_menu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _resume() -> void :
	world.game_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _retry() -> void:
	world.game_paused = false
	world.retry()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_toggled_game_paused(is_paused : bool):
	if(is_paused):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		hide()
