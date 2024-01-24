@tool
class_name SpiralUVShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "SpiralUV"


func _get_category():
	return "UVUtils"


func _get_description():
	return "Returns transformed UV coordinate constructed by multiple inset coordinates with the specified rotation and scale."


func _init():
	set_input_port_default_value(1, PI/4.0)
	set_input_port_default_value(2, 0.75);
	set_input_port_default_value(3, 5);


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 4


func _get_input_port_name(port):
	match port:
		0:
			return "UV [default]"
		1:
			return "Rotation"
		2:
			return "Scale (0~1)"
		3:
			return "Nests (>0)"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_output_port_count():
	return 2


func _get_output_port_name(port):
	match port:
		0:
			return "UV"
		1:
			return "Nest"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_code(input_vars, output_vars, mode, type):
	
	if !input_vars[0]:
		input_vars[0] = "UV" # default
	
	return """
	vec2 uv = {InUV};
	float rotation = - {InRotation};
	float scale = {InScale};
			
	if (int({InNests}) <= 0) {
		{OutUV} = uv;
		{OutNest} = 0.0;
	} 
	else {
		int nest = 1;
		for (; nest <= int({InNests}); nest++) {
			
			vec2 uv_centered = (uv - vec2(0.5, 0.5)) / scale;
			
			float sin_th = sin(rotation);
			float cos_th = cos(rotation);
			
			float x = uv_centered.x * cos_th - uv_centered.y * sin_th;
			float y = uv_centered.x * sin_th + uv_centered.y * cos_th;
			
			vec2 uv2 = vec2(x + 0.5, y + 0.5);
			
			if ((0.0 <= uv2.x && uv2.x <= 1.0) && (0.0 <= uv2.y && uv2.y <= 1.0)) {
				uv = uv2;
			}
			else {
				break;
			}
		}
		
		{OutUV} = uv;
		{OutNest} = float(nest);
	}
	
	
""".format({"InUV":input_vars[0],
			"InRotation":input_vars[1],
			"InScale":input_vars[2],
			"InNests":input_vars[3],
			"OutUV":output_vars[0],
			"OutNest":output_vars[1]})
