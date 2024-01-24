@tool
class_name TransformedUVShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "TransformedUV"


func _get_category():
	return "UVUtils"


func _get_description():
	return "Returns transformed UV coordinate with the specified rotation and scale."


func _init():
	set_input_port_default_value(1, PI/4.0)
	set_input_port_default_value(2, 0.75);


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "UV [default]"
		1:
			return "Rotation"
		2:
			return "Scale"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR


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
	
	if !input_vars[0]:
		input_vars[0] = "UV" # default
	
	return """
	vec2 uv = {InUV};
	float rotation = {InRotation};
	float scale = 1.0/{InScale};
	
	vec2 uv_centered = (uv - vec2(0.5, 0.5)) / scale;
			
	float sin_th = sin(rotation);
	float cos_th = cos(rotation);
	
	float x = uv_centered.x * cos_th - uv_centered.y * sin_th;
	float y = uv_centered.x * sin_th + uv_centered.y * cos_th;
	
	{OutUV} = vec2(x + 0.5, y + 0.5);
	
	
""".format({"InUV":input_vars[0],
			"InRotation":input_vars[1],
			"InScale":input_vars[2],
			"OutUV":output_vars[0]})
