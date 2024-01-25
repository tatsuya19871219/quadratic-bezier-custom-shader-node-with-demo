@tool
class_name ConvertToQuadBezierCoordShaderNode
extends VisualShaderNodeCustom

const quad_bezier_solver_shaderinc: ShaderInclude = preload("./quad_bezier_solver.gdshaderinc")


func _get_name():
	return "ConvertToQuadBezierCoord"


func _get_category():
	return "QuadBezier"


func _get_description():
	return "Converts the coordinate along the quadratic bezier curve specified by the given parameters."


func _init():
	set_input_port_default_value(1, Vector2(0.0, 0.0))
	set_input_port_default_value(2, Vector2(0.0, 1.0))
	set_input_port_default_value(3, Vector2(1.0, 1.0))


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 4


func _get_input_port_name(port):
	match port:
		0:
			return "UV [default]"
		1:
			return "Initial Point"
		2:
			return "Control Point"
		3:
			return "Last Point"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		3:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D


func _get_output_port_count():
	return 4


func _get_output_port_name(port):
	match port:
		0:
			return "Quad Bezier Coord"
		1:
			return "Unit Normal"
		2:
			return "Foot"
		3:
			return "Curve Length"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		2:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		3:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_global_code(mode):
	return quad_bezier_solver_shaderinc.code


func _get_code(input_vars, output_vars, mode, type):
	
	if input_vars[0].is_empty():
		input_vars[0] = "UV" # default
		
	return """
	
	{OutQBezierCoord} 
		= qbezier_get_principal_coord({InUV}, {InInitPoint}, {InControlPoint}, {InLastPoint});
							
	{OutUnitNormal} = qbezier_curve_unit_normal({OutQBezierCoord}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	{OutFoot} = qbezier_curve({OutQBezierCoord}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	
	{OutCurveLength} 
		= qbezier_calc_curve_length(1.0, {InInitPoint}, {InControlPoint}, {InLastPoint});
""".format({"InUV":input_vars[0], 
			"InInitPoint":input_vars[1],
			"InControlPoint":input_vars[2],
			"InLastPoint":input_vars[3],
			"OutQBezierCoord":output_vars[0],
			"OutUnitNormal":output_vars[1],
			"OutFoot":output_vars[2],
			"OutCurveLength":output_vars[3]})
