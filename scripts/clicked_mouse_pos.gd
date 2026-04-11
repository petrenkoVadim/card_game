extends Node
		
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = $Sprite2D.get_local_mouse_position()
		var rect = $Sprite2D.get_rect()
		
		if rect.has_point(mouse_pos):
			emit_signal("clicked")
