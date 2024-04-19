extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_category("World")
@export var world : World

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer

func _ready():
	position = world.PLAYER_SPAWN
	velocity.y = 0
	velocity.x = 0

func _process(delta):
	var player_pos = position.floor()
	if(player_pos.y < world.WORLD_BOUNDS.z || player_pos.y > world.WORLD_BOUNDS.w || player_pos.x < world.WORLD_BOUNDS.x || player_pos.x > world.WORLD_BOUNDS.y):
		position = world.PLAYER_SPAWN

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
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
