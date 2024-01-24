@tool
class_name SolutionsToCasesShaderNode
extends VisualShaderNodeCustom


func _get_name():
	return "SolutionsToCases"


func _get_category():
	return "QuadBezier/Utils"


func _get_description():
	return "Returns flags to represent cases from number of (real) solutions."


func _init():
	set_input_port_default_value(0, 0)


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 1


func _get_input_port_name(port):
	match port:
		0:
			return "Solutions"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR_INT


func _get_output_port_count():
	return 4


func _get_output_port_name(port):
	match port:
		0:
			return "== 0"
		1:
			return ">= 1"
		2:
			return ">= 2"
		3:
			return ">= 3"


func _get_output_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		1:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		2:
			return VisualShaderNode.PORT_TYPE_BOOLEAN
		3:
			return VisualShaderNode.PORT_TYPE_BOOLEAN


func _get_code(input_vars, output_vars, mode, type):
	
	return """
	{Out0} = {InSolutions} == 0;
	{Out1} = {InSolutions} >= 1;
	{Out2} = {InSolutions} >= 2;
	{Out3} = {InSolutions} >= 3;
""".format({"InSolutions":input_vars[0], 
			"Out0":output_vars[0],
			"Out1":output_vars[1],
			"Out2":output_vars[2],
			"Out3":output_vars[3]})
