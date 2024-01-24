@tool
class_name DebugConvertToQuadBezierCoordShaderNode
extends VisualShaderNodeCustom

const quad_bezier_solver_shaderinc: ShaderInclude = preload("res://shader/quad_bezier_solver.gdshaderinc")


func _get_name():
	return "ConvertToQuadBezierCoord_DEBUG"


func _get_category():
	return "QuadBezier"


func _get_description():
	return "[Only for debug purpose] Converts the coordinate along the quadratic bezier curve specified by the given parameters."


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
	return 11


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
		4:
			return "Quad Bezier Coord (raw-0)"
		5:
			return "Quad Bezier Coord (raw-1)"
		6:
			return "Quad Bezier Coord (raw-2)"
		7:
			return "Unit Normal (raw-0)"
		8:
			return "Unit Normal (raw-1)"
		9:
			return "Unit Normal (raw-2)"
		10:
			return "Real Solutions"


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
		4:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		5:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		6:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		7:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		8:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		9:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		10:
			return VisualShaderNode.PORT_TYPE_SCALAR_INT


func _get_global_code(mode):
	return quad_bezier_solver_shaderinc.code


func _get_code(input_vars, output_vars, mode, type):
	
	if !input_vars[0]:
		input_vars[0] = "UV" # default
		
	return """
	{OutQBezierCoord} 
		= qbezier_get_coord({InUV}, {InInitPoint}, {InControlPoint}, {InLastPoint}, 
							{OutRawQBezierCoord0}, {OutRawQBezierCoord1}, {OutRawQBezierCoord2},
							{OutRealSolutions});
							
	{OutUnitNormal} = qbezier_curve_unit_normal({OutQBezierCoord}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	{OutFoot} = qbezier_curve({OutQBezierCoord}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	
	{OutUnitNormal0} = qbezier_curve_unit_normal({OutRawQBezierCoord0}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	{OutUnitNormal1} = qbezier_curve_unit_normal({OutRawQBezierCoord1}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	{OutUnitNormal2} = qbezier_curve_unit_normal({OutRawQBezierCoord2}.x, {InInitPoint}, {InControlPoint}, {InLastPoint});
	
	{OutCurveLength} 
		= qbezier_calc_curve_length(1.0, {InInitPoint}, {InControlPoint}, {InLastPoint});
""".format({"InUV":input_vars[0], 
			"InInitPoint":input_vars[1],
			"InControlPoint":input_vars[2],
			"InLastPoint":input_vars[3],
			"OutQBezierCoord":output_vars[0],
			"OutUnitNormal":output_vars[1],
			"OutFoot":output_vars[2],
			"OutCurveLength":output_vars[3],
			"OutRawQBezierCoord0": output_vars[4],
			"OutRawQBezierCoord1": output_vars[5],
			"OutRawQBezierCoord2": output_vars[6],
			"OutUnitNormal0": output_vars[7],
			"OutUnitNormal1": output_vars[8],
			"OutUnitNormal2": output_vars[9],
			"OutRealSolutions": output_vars[10]})
