extends Area2D
class_name CardInput

signal card_clicked
signal card_right_clicked
signal card_hovered(is_hovered: bool)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			card_clicked.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			card_right_clicked.emit()

func _on_mouse_entered():
	card_hovered.emit(true)

func _on_mouse_exited():
	card_hovered.emit(false)
