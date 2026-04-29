extends Area2D
class_name SkillInput

signal skill_clicked
signal skill_hovered(is_hovered: bool)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			skill_clicked.emit()

func _on_mouse_entered():
	skill_hovered.emit(true)

func _on_mouse_exited():
	skill_hovered.emit(false)
