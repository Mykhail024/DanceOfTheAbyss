extends CanvasLayer

@export_category("World")
@export var world : World

func _retry() -> void:
	world.retry()
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if(visible and event.is_action_pressed("Confirm")):
		_retry()

func show_dead_screen() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
