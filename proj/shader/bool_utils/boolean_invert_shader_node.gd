@tool
class_name InvertShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "Invert"


func _get_category():
	return "BoolUtils"


func _get_description():
	return "Returns true if input is false."


func _init():
	set_input_port_default_value(0, false)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 1


func _get_input_port_name(port):
	match port:
		0:
			return "A"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	match port:
		0:
			return "Out"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_code(input_vars, output_vars, mode, type):
	
	return """
	{Out} = !{InA};
""".format({"InA":input_vars[0],
			"Out":output_vars[0]})
