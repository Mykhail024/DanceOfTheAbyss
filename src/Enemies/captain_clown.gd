extends CharacterBody2D
class_name CaptainClown

@export var SPEED : float = 1000
@export var JUMP_VELOCITY : float = -250.0
@export var damage : float = 50

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected : bool = false
var player_in_attack_area : bool = false
var player : Player

var attacks = ["Attack_1", "Attack_2", "Attack_3"]

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

func player_kick():
	player.emit_signal("update_health", player.health - damage)
	player.hit()
	if(player.health <= 0):
		_on_player_detection_body_exited(player)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player_in_attack_area and player.health > 0:
		velocity.x = 0
		if(!animPlayer.is_playing() || animPlayer.current_animation == "Idle" and ($RayCast2D_Left.is_colliding() or $RayCast2D_Right.is_colliding())):
			animPlayer.play(attacks.pick_random())
	elif player_detected and player.health > 0:
		if velocity.y > 0:
			animPlayer.play("Fall_sword")
		var direction = get_player_direction()
		
		flip_to_player_direction(direction)
		animPlayer.play("Run_sword")
		
		if(is_on_wall() and is_on_floor() or (is_on_floor() and (!$RayCast2D_Left.is_colliding() and ($RayCast2D_Platform_Left.is_colliding() or $RayCast2D_Platform_Left2.is_colliding()) or !$RayCast2D_Right.is_colliding() and ($RayCast2D_Platform_Right.is_colliding() or $RayCast2D_Platform_Right2.is_colliding())))):
			velocity.y = JUMP_VELOCITY
			animPlayer.play("Jump_sword")
			
		velocity.x = direction.x * SPEED
	else:
		velocity.x = 0
		if velocity.y > 0:
			animPlayer.play("Fall")
		else:
			if(!animPlayer.is_playing()):
				animPlayer.play("Idle")
	move_and_slide()

func _on_player_detection_body_entered(body):
	if (body.name == "Player"):
		animPlayer.play("Sword_unsheathing")
		await animPlayer.animation_finished
		player_detected = true

func _on_player_detection_body_exited(body):
	if (body.name == "Player"):
		player_detected = false
		animPlayer.play("Sword_sheathing")

func _on_attack_detection_body_entered(body):
	if (body.name == "Player"):
		player_in_attack_area = true
		animPlayer.stop()

func _on_attack_detection_body_exited(body):
	if (body.name == "Player"):
		player_in_attack_area = false
