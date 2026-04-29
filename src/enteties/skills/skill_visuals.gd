extends Node
class_name SkillVisuals

@onready var skill_sprite = owner.get_node_or_null("Sprite2D")
@onready var amount_label = owner.get_node_or_null("LabelAmount")

func update_view(data: Dictionary):
	if skill_sprite and data.get("texture"):
		skill_sprite.texture = data["texture"]
		skill_sprite.show()
	
	if amount_label:
		var amount = data.get("amount", 0)
		amount_label.text = str(amount) if amount > 0 else ""
