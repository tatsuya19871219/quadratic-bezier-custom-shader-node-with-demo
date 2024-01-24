@tool
class_name InQuadBezierSegmentShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "InQuadBezierSegment"


func _get_category():
	return "QuadBezier"


func _get_description():
	return "Returns true if the given quadratic bezier coordination is in the segment."


func _init():
	set_input_port_default_value(1, 0.1)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 2


func _get_input_port_name(port):
	match port:
		0:
			return "QuadBezierCoord"
		1:
			return "Half Width"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR


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
	float t = {InCoord}.x;
	float displacement = {InCoord}.y;
	{Out} = (t >= 0.0 && t <= 1.0) && (abs(displacement) <= {InHalfWidth});
""".format({"InCoord":input_vars[0], 
			"InHalfWidth":input_vars[1],
			"Out":output_vars[0]})
