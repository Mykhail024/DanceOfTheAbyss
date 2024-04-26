extends CanvasLayer
class_name UI

@export var show_cordinates : bool;
@export var show_health : bool = true;

@export var player : Player

func _ready() -> void:
	player.connect("update_health", _on_health_update)
	player.connect("reset_health", _on_health_reset)
	player.connect("update_money", _on_update_money)
	_on_health_reset()

func _process(delta):
	update_cordinates(player.position.floor())

func enable_cordinates(val : bool):
	show_cordinates = val

func enable_health(val : bool):
	show_health = val

func update_cordinates(val : Vector2):
	if(show_cordinates):
		$Cordinates.text = "Cordinates: " + str(val.x) + ", " + str(val.y)
	else:
		$Cordinates.text = ""

func _on_health_update(_value: float) -> void:
	var tween = create_tween()
	tween.tween_property($Health/HealthOver, "value", _value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Health/HealthUnder, "value", _value, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_health_reset() -> void:
	$Health/HealthOver.value = player.max_health
	$Health/HealthUnder.value = player.max_health

func _on_update_money(money : int):
	$Money.text = "Money: " + str(money)
