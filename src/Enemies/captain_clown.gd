extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -280.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player : CharacterBody2D
var chase : bool = false

func _physics_process(delta):
	velocity.y += gravity * delta
	if chase:
		get_node("AnimatedSprite2D").play("Run_sword")
		player = get_node("../../PlayerNode/Player")
		var direction = (player.position - self.position).normalized()
		if(is_on_wall() and is_on_floor()):
			velocity.y = JUMP_VELOCITY
			get_node("AnimatedSprite2D").play("Jump_sword")
		elif(direction.x <= 0):
			get_node("AnimatedSprite2D").flip_h = true
		elif (direction.x > 0):
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0
	move_and_slide()

func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		get_node("AnimatedSprite2D").play("Throw_sword_reverse")
		chase = true


func _on_area_2d_body_exited(body):
	if (body.name == "Player"):
		chase = false
		get_node("AnimatedSprite2D").play("Throw_sword")
