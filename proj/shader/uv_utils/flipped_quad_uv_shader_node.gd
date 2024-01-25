@tool
class_name FlippedQuadUVShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "FlippedQuadUV"


func _get_category():
	return "UVUtils"


func _get_description():
	return "Returns transformed UV coordinate of 4 tiles with flipping."


func _init():
	set_input_port_default_value(1, true)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 2


func _get_input_port_name(port):
	match port:
		0:
			return "UV [default]"
		1:
			return "Inward"


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
	vec2 uv2 = {InUV} * vec2(2.0, 2.0);
	
	vec2 ij = floor(uv2);
	vec2 st = fract(uv2);
	
	float x = int(ij.x) == 0 ? st.x : 1.0 - st.x;
	float y = int(ij.y) == 0 ? st.y : 1.0 - st.y;
	
	{OutUV} = {InIsInward} ? vec2(x, y) : vec2(1.0 - x, 1.0 - y);
	
""".format({"InUV":input_vars[0],
			"InIsInward":input_vars[1],
			"OutUV":output_vars[0]})
