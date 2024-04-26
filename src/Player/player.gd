extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_category("World")
@export var world : World
@export var max_health : float = 100.0

var health : int = max_health
var money : int = 0
var direction : int

signal update_health(amount : float)
signal reset_health
signal update_money(mount : float)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer

func _ready():
	position = world.PLAYER_SPAWN
	velocity.y = 0
	velocity.x = 0
	connect("update_health", _on_health_update)
	connect("reset_health", _on_health_reset)
	connect("update_money", _on_money_update)

func _on_health_update(_value: float) -> void:
	health = _value
	if(health <= 0):
		dead()
func _on_health_reset() -> void:
	health = max_health
	
func _on_money_update(val : int) -> void:
	money = val

func _process(delta):
	var player_pos = position.floor()
	if(player_pos.y < world.WORLD_BOUNDS.z || player_pos.y > world.WORLD_BOUNDS.w || player_pos.x < world.WORLD_BOUNDS.x || player_pos.x > world.WORLD_BOUNDS.y):
		position = world.PLAYER_SPAWN
		emit_signal("update_health", health - max_health/2)

func _physics_process(delta):
	if(health <= 0):
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("Left", "Right")
	if direction:
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		elif direction == 1:
			$AnimatedSprite2D.flip_h = false
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animation_player.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animation_player.play("Idle")
	if velocity.y > 0:
		animation_player.play("Fall")
	move_and_slide()

func hit():
	var tween = create_tween()
	tween.tween_property(self, "velocity", Vector2(velocity.x, velocity.y - 25), 0.1)

func dead():
	var tween = create_tween()
	var mod = modulate
	mod.a = 0
	tween.tween_property(self, "modulate", mod, 0.3)
	await tween.finished
	get_node("../../Controls/DeadScreen").show_dead_screen()
