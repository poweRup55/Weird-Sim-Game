# Player script
extends KinematicBody2D

# Variables

export (int) var max_speed = 400
export (int) var acceleration = 2000
export (int) var friction = 2000

export (bool) var enabled = true

var velocity = Vector2()
var action = false
var colider = null
var start_pos = self.position

# Functions

func animation_movement(right,left,down,up):
#	In charge of the animation of the charcter

	if right and not up and not down:
		$walk_animation.flip_h = false
		$walk_animation.play("side")
	elif left and not up and not down:
		$walk_animation.flip_h = true
		$walk_animation.play("side")
	elif down and not right and not left:
		$walk_animation.play("down")
	elif up and not right and not left:
		$walk_animation.play("up")
	elif up and right:
		$walk_animation.flip_h = false
		$walk_animation.play("up side")
	elif up and left:
		$walk_animation.flip_h = true
		$walk_animation.play("up side")
	elif down and right:
		$walk_animation.flip_h = false
		$walk_animation.play("down side")
	elif down and left:
		$walk_animation.flip_h = true
		$walk_animation.play("down side")
	else:
		$walk_animation.play("standing")
		
func get_input(delta):
	#	Input handler
	
	var input_vector = Vector2.ZERO
	var is_right_presed = Input.is_action_pressed('ui_right')
	var is_left_presed = Input.is_action_pressed('ui_left')
	var is_down_presed = Input.is_action_pressed('ui_down')
	var is_up_presed = Input.is_action_pressed('ui_up')
	#	Adds to velocity
	
	if is_right_presed:
		input_vector.x += 1
	if is_left_presed:
		input_vector.x -= 1
	if is_down_presed:
		input_vector.y += 1
	if is_up_presed:
		input_vector.y -= 1
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration*delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	animation_movement(is_right_presed,is_left_presed,is_down_presed,is_up_presed)

func _physics_process(delta):
	#	Movement of player
	if not GameManager.is_dead and enabled:
		get_input(delta)
		var collision = move_and_collide(velocity * delta)
		if collision:
			colider = collision.get_collider()
			if colider.get_parent().name != "Items": #checks if collider is an item.
				colider = null
			velocity = velocity.slide(collision.normal)
		else:
			colider = null
		velocity = move_and_slide(velocity)
		
func _process(_delta):
	if not GameManager.is_dead:
		if Input.is_action_pressed('ui_action') and colider:
			colider.action()
		if Input.is_action_just_released('ui_action') and colider:
			colider.end_action()
	else:
		death_animation()

func death_animation():
	if $walk_animation.frame == 20:
		$walk_animation.speed_scale = 0.5
	if $walk_animation.frame == 28:
		GameManager.game_over()
		$walk_animation.frame = 26				

func _ready():
	$walk_animation.speed_scale = 1

func die():
	$walk_animation.show()
	$walk_animation.flip_h = false
	$walk_animation.play("death")
	

func disable():
	enabled = false
	$walk_animation.hide()

func enable():
	enabled = true
	$walk_animation.show()

func restart():
	# Restart logic 
	
	self.position = start_pos
	$walk_animation.speed_scale = 1
	$walk_animation.play("standing")
	enable()
