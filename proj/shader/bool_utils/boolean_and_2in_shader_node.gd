@tool
class_name TwoInputAndShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "And_2"


func _get_category():
	return "BoolUtils"


func _get_description():
	return "Returns true if both inputs are true."


func _init():
	set_input_port_default_value(0, false)
	set_input_port_default_value(1, false)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 2


func _get_input_port_name(port):
	match port:
		0:
			return "A"
		1:
			return "B"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		1:
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
	{Out} = {InA} && {InB};
""".format({"InA":input_vars[0],
			"InB":input_vars[1], 
			"Out":output_vars[0]})
