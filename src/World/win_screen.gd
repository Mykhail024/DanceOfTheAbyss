extends CanvasLayer

func _go_to_main_menu() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://src/MainMenu/main_menu.tscn")

func _input(event):
	if(visible and event.is_action_pressed("Confirm")):
		_go_to_main_menu()

func show_win_screen() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	get_tree().paused = true
