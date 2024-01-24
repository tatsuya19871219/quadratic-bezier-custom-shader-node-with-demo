@tool
class_name VectorToAngleShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "VectorToAngle"


func _get_category():
	return "QuadBezier/Utils"


func _get_description():
	return "Returns angle from Vector2."


func _init():
	set_input_port_default_value(0, Vector2(0, 0))


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_input_port_count():
	return 1


func _get_input_port_name(port):
	match port:
		0:
			return "Vector"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_output_port_count():
	return 2


func _get_output_port_name(port):
	match port:
		0:
			return "Angle"
		1:
			return "Pseudo Color (HSV)"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_3D


func _get_code(input_vars, output_vars, mode, type):
	
	return """
	{OutAngle} = atan({InVector}.y, {InVector}.x);
	{OutColor} = vec3({OutAngle}/TAU + 0.5, 1.0, 1.0);
""".format({"InVector":input_vars[0], 
			"OutAngle":output_vars[0],
			"OutColor":output_vars[1]})
