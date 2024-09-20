extends ColorRect
class_name lighting

# Called when the node enters the scene tree for the first time.
func _ready():
	show() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var light_positions = _get_light_positions()
	material.set_shader_parameter("number_of_lights",light_positions.size())
	material.set_shader_parameter("lights", light_positions)

func _get_light_positions():
	return get_tree().get_nodes_in_group("lights").map(
		func(light: Node2D):
			print(light.get_parent().get_global_transform_with_canvas().origin)
			return light.get_parent().get_global_transform_with_canvas().origin
	)
