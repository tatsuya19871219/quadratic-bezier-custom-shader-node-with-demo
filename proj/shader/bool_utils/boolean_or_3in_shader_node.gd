@tool
class_name ThreeInputOrShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "Or_3"


func _get_category():
	return "BoolUtils"


func _get_description():
	return "Returns true if any input is true."


func _init():
	set_input_port_default_value(0, false)
	set_input_port_default_value(1, false)
	set_input_port_default_value(2, false)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "A"
		1:
			return "B"
		2:
			return "C"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		1:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		2:
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
	{Out} = {InA} || {InB} || {InC};
""".format({"InA":input_vars[0], 
			"InB":input_vars[1],
			"InC":input_vars[2],
			"Out":output_vars[0]})
