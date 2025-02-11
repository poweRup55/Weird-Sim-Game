# Responsible on placing the stats bar on the screen
 
extends ReferenceRect

# Variables 

var children = Array()
export (float) var min_shake = 10
export (float) var shake_quant = 20

# Functions

func shake(obj,rng):
	# Shakes the stat bar
	
	rng.randomize()
	var x = rng.randf_range(min_shake, shake_quant) * pick_minus(rng)
	var y = rng.randf_range(min_shake, shake_quant) * pick_minus(rng)
	var add_to = Vector2(x,y)
	obj.set_global_position(obj.get_global_position() + add_to)

func pick_minus(rng):
	# Randomly picks 1 or -1
	
	if rng.randi_range(0,1) == 1:
		return 1
	else:
		return -1

func child_been_added(child):
	# Signals that a stat has been added
	
	children.append(child)
	update_children_loc()

func remove_child(child):
	# Signals that a stat has been removed
	
	children.erase(child)
	update_children_loc()

func update_children_loc():
	# Updates stats bars location
	
	var child_rect = Vector2(0,0)
	for i in len(children):
		var child = children[i]
		var child_scale = rect_size[1] / child.rect_size[1]
		child.set_scale(Vector2(child_scale,child_scale))
		var new_pos = Vector2(get_global_position()[0] + child_rect[0] * i ,get_global_position()[1])
		child.set_global_position(new_pos)
		child.og_pos = new_pos
		child_rect = child.rect_size * child.get_scale()

func return_to_og_pos(child, og_pos):
	# Returns a stat to its original position
	
	if og_pos != child.get_global_position():
		child.set_global_position(og_pos)
