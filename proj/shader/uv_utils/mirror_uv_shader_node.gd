@tool
class_name MirroredUVShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "MirroredUV"


func _get_category():
	return "UVUtils"


func _get_description():
	return "Returns transformed UV with mirrored coordinate separated by vertical/horizontal center."


func _init():
	set_input_port_default_value(1, true);


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 2


func _get_input_port_name(port):
	match port:
		0:
			return "UV [default]"
		1:
			return "Vertical"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	match port:
		0:
			return "UV"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_code(input_vars, output_vars, mode, type):
	
	if input_vars[0].is_empty():
		input_vars[0] = "UV" # default
	
	return """
	if ({InIsVertical}) {
		{OutUV} = {InUV}.x < 0.5
					? {InUV}
					: vec2(1.0 - {InUV}.x, {InUV}.y);
	}
	else {
		{OutUV} = {InUV}.y < 0.5
					? {InUV}
					: vec2({InUV}.x, 1.0 - {InUV}.y);
	}
	
""".format({"InUV":input_vars[0],
			"InIsVertical":input_vars[1],
			"OutUV":output_vars[0]})
