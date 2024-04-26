extends Node2D

@export_category("NextLevelPotion")
@export var is_enabled : bool = false

func _ready():
	modulate.a = 0

func show_potion() -> void:
	var tween = create_tween()
	var mod = modulate
	mod.a = 255
	tween.tween_property(self, "modulate", mod, 10)
	is_enabled = true


func _on_area_body_entered(body):
	if(body.name == "Player" && is_enabled):
		get_parent().get_node("Controls/GoToPotion").visible = false
		get_parent().get_node("Controls/WinScreen").show_win_screen()
