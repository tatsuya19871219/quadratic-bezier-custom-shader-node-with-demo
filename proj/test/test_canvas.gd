extends ColorRect

const CP0_name = "InitialPoint"
const CP1_name = "ControlPoint"
const CP2_name = "LastPoint"

@onready var CP0 = $P0
@onready var CP1 = $P1
@onready var CP2 = $P2

@onready var qbezier_material = self.material

var active_point: StaticBody2D = null

func _ready():
	
	var p0_initial = qbezier_material.get_shader_parameter(CP0_name)
	CP0.var_name = CP0_name;
	CP0.position = get_relative_position(p0_initial)
	
	var p1_initial = qbezier_material.get_shader_parameter(CP1_name)
	CP1.var_name = CP1_name;
	CP1.position = get_relative_position(p1_initial)
	
	var p2_initial = qbezier_material.get_shader_parameter(CP2_name)
	CP2.var_name = CP2_name;
	CP2.position = get_relative_position(p2_initial)

func _process(delta):
	
	if active_point != null:
		active_point.position = self.get_local_mouse_position()
		
		qbezier_material.set_shader_parameter(active_point.var_name, get_normalized_position(active_point.position))
	
	pass

func get_normalized_position(point: Vector2) -> Vector2:
	return Vector2(point.x/size.x, point.y/size.y)

func get_relative_position(normalized_position: Vector2) -> Vector2:
	return Vector2(normalized_position.x*size.x, normalized_position.y*size.y)


func _set_active_point(target):
	active_point = target
	
func _unset_active_point(target):
	active_point = null
