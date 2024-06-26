extends Control

var center : Vector2
@onready var node = $Background

func _ready():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

#process
func _process(delta):
	var tween = node.create_tween()
	var offset = (center - get_global_mouse_position()) * 0.3
	tween.tween_property(node, "position", offset, 1.0)

func exit():
	get_tree().quit();

func play():
	get_tree().change_scene_to_file("res://src/World/Levels/Lvl1.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func settings():
	pass

func _on_item_rect_changed():
	_ready()
