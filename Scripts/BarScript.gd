# Progress meter script

extends TextureProgress

# Variables

var old_layer_mask = 0
var old_collision_mask = 0
onready var static_body = $StaticBody2D

# Functions

func _ready():
	old_layer_mask = static_body.get_collision_layer()
	old_collision_mask = static_body.get_collision_mask()
	hide()

func enable_action():
	show()
	static_body.set_collision_layer(old_layer_mask)
	static_body.set_collision_mask(old_collision_mask)
	
	
func disable_action():
	hide()
	static_body.set_collision_layer(0)
	static_body.set_collision_mask(0)
