@tool
class_name WithinRangeShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "WithinRange"


func _get_category():
	return "BoolUtils"


func _get_description():
	return "Returns true if the given value is within the range."


func _init():
	set_input_port_default_value(1, 0.0)
	set_input_port_default_value(2, 1.0)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "Value"
		1:
			return "From"
		2:
			return "To"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	match port:
		0:
			return "Within"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_code(input_vars, output_vars, mode, type):
	
	return """
	{OutWithin} = ({InValue} >= {InFrom}) && ({InValue} <= {InTo});
""".format({"InValue":input_vars[0], 
			"InFrom":input_vars[1],
			"InTo":input_vars[2],
			"OutWithin":output_vars[0]})
