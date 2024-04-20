extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -280.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase : bool = false
var player : CharacterBody2D

@onready var animSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	set_floor_block_on_wall_enabled(false)
	set_slide_on_ceiling_enabled(false)
	player = get_node("../../PlayerNode/Player")

func get_player_direction():
	return (player.position - self.position).normalized()

func flip_to_player_direction(direction):
	if(direction.x <= 0):
		animSprite.flip_h = true
	else:
		animSprite.flip_h = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase:
		if velocity.y > 0:
			animPlayer.play("Fall_sword")
		
		var direction = get_player_direction()
		
		flip_to_player_direction(direction)
		if (!animPlayer.is_playing()):
			animPlayer.play("Run_sword")
		
		if(is_on_wall() and is_on_floor()):
			velocity.y = JUMP_VELOCITY
			animPlayer.play("Jump_sword")
		velocity.x = direction.x * SPEED
	else:
		velocity.x = 0
		if(!animPlayer.is_playing()):
			animPlayer.play("Idle")
		if velocity.y > 0:
			animPlayer.play("Fall")
	move_and_slide()

func _on_player_detection_body_entered(body):
	if (body.name == "Player"):
		flip_to_player_direction(get_player_direction())
		animPlayer.play("Sword_unsheathing")
		await animPlayer.animation_finished
		chase = true

func _on_player_detection_body_exited(body):
	if (body.name == "Player"):
		chase = false
		animPlayer.play("Sword_sheathing")

func _on_attack_detection_body_entered(body):
	if (body.name == "Player"):
		chase = false
		animPlayer.play("Attack")

func _on_attack_detection_body_exited(body):
	if (body.name == "Player"):
		chase = true
		animPlayer.play("Run_sword")
