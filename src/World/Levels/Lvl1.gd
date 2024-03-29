extends Node2D

class_name World

const WORLD_BOUNDS : Vector4 = Vector4(-1200, 1200, -600, 300)
const PLAYER_SPAWN : Vector2 = Vector2(0, 0)

signal pause_toggled(is_paused : bool)

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("pause_toggled", game_paused)

@onready var player : CharacterBody2D = $Player
@onready var posLabel : Label = $pos/Pos

func _process(delta):
	var player_pos = player.position.floor()
	posLabel.text = "Cordinates: " + str(player_pos.x) + ", " + str(player_pos.y)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused

func retry() -> void:
	get_tree().change_scene_to_file("res://src/World/Levels/Lvl1.tscn")
