extends Node2D

class_name World

const WORLD_BOUNDS : Vector4 = Vector4(-1200, 3600, -3600, 600)
const PLAYER_SPAWN : Vector2 = Vector2(0, 0)

@onready var world_money : int = $Money.get_used_cells_by_id(0).size()

signal pause_toggled(is_paused : bool)

func _ready():
	$PlayerNode/Player.connect("update_money", check_win)
	game_paused = false
		

func check_win(money : int):
	if(world_money <= $PlayerNode/Player.money):
		$NextLevelPotion.show_potion()
		$Controls/GoToPotion.visible = true

var game_paused: bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("pause_toggled", game_paused)

@onready var player : Player = $PlayerNode/Player
@onready var UI : UI = $Controls/UI

func _input(event):
	if event.is_action_pressed("ui_cancel") and player.health > 0:
		game_paused = !game_paused
	elif event.is_action_pressed("Show Cordinates"):
		UI.enable_cordinates(!UI.show_cordinates)

func retry() -> void:
	game_paused = false
	get_tree().change_scene_to_file("res://src/World/Levels/Lvl1.tscn")
