extends Label

@export var target_label: String
@export var target_path: NodePath
#@export var canvas_size: Vector2
@export var target_canvas_path: NodePath

@onready var target = get_node(target_path)
@onready var canvas_size = get_node(target_canvas_path).size

func _process(delta):
	var x = target.position.x / canvas_size.x
	var y = target.position.y / canvas_size.y
	self.text = "%s = (%3.2f, %3.2f)" % [target_label, x, y]
