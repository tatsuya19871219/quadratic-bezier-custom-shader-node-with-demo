@tool
class_name MaskFloatShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "MaskFloat"


func _get_category():
	return "UVUtils"


func _get_description():
	return "Returns input value if mask is true, otherwise returns default value. 
	Completely same as 'Switch' node, except for input port names."


func _init():
	set_input_port_default_value(0, false)
	set_input_port_default_value(2, 0.0)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "Mask"
		1:
			return "Input value"
		2:
			return "Default value"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	match port:
		0:
			return "Output value"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_code(input_vars, output_vars, mode, type):
	
	return """
	{OutValue} = {InMask} ? {InValue} : {InDefault};
""".format({"InMask":input_vars[0],
			"InValue":input_vars[1],
			"InDefault":input_vars[2],
			"OutValue":output_vars[0]})
