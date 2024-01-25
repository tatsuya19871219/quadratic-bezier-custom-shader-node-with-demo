@tool
class_name WavedUVShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "WavedUV"


func _get_category():
	return "UVUtils"


func _get_description():
	return "Returns transformed UV coordinate constructed with wave-like tile."


func _init():
	set_input_port_default_value(1, false)
	set_input_port_default_value(2, Vector2(5, 3));


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "UV [default]"
		1:
			return "Alternated"
		2:
			return "Repeats"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_output_port_count():
	return 2


func _get_output_port_name(port):
	match port:
		0:
			return "UV"
		1:
			return "WaveCoord"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_code(input_vars, output_vars, mode, type):
	
	if input_vars[0].is_empty():
		input_vars[0] = "UV" # default
	
	return """
	vec2 uv2 = {InUV} * {InRepeats};
	
	vec2 ij = floor(uv2);
	vec2 st = fract(uv2);
	
	float x = st.x;
	float y = int(ij.x) % 2 == 0 ? st.y : 1.0 - st.y;
	if ({InIsAlternated} && int(ij.y) % 2 == 1) {
		y = 1.0 - y;
	}
	
	{OutUV} = vec2(x, y);
	{OutWaveCoord} = ij;
	
""".format({"InUV":input_vars[0],
			"InIsAlternated":input_vars[1],
			"InRepeats": input_vars[2],
			"OutUV":output_vars[0],
			"OutWaveCoord":output_vars[1]})
