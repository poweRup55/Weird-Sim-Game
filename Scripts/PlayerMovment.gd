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


onready var animationTree = $AnimationTree
onready var animationState = animationTree.get('parameters/playback')

# Functions
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
		animationTree.set('parameters/idle/blend_position', input_vector)
		animationTree.set('parameters/Run/blend_position', input_vector)
		animationState.travel('Run')
		velocity = velocity.move_toward(input_vector * max_speed, acceleration*delta)
	else:
		animationState.travel('idle')
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

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

func _ready():
	$AnimationTree.active = true

func die():
	$walk_animation.show()
	animationState.travel('death')

func disable():
	enabled = false
	$walk_animation.hide()

func enable():
	enabled = true
	$walk_animation.show()

func restart():
	# Restart logic 
	self.position = GameManager.player_start_position
	$AnimationTree.active = true
	animationState.travel('Run')
	enable()

func _on_AnimationPlayer_death_finished():
	GameManager.game_over()
		
