extends StaticBody2D

signal selected(StaticBody2D)
signal deselected(StaticBody2D)

var var_name: String = "name"

func _on_point_input_event(viewport, event, shape_idx):
	
	var mouse_button_event = event as InputEventMouseButton
	
	if mouse_button_event != null && mouse_button_event.is_pressed():
		
		match mouse_button_event.button_index:
			MOUSE_BUTTON_LEFT:
				selected.emit(self)
			MOUSE_BUTTON_RIGHT:
				deselected.emit(self)
	
