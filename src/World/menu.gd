extends CanvasLayer

@export_category("World")
@export var world : World

func _ready():
	world.connect("pause_toggled", _on_toggled_game_paused)

func _main_menu() -> void:
	world.game_paused = false
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")

func _resume() -> void :
	world.game_paused = false

func _retry() -> void:
	world.game_paused = false
	world.retry()

func _on_toggled_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()
