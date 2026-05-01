extends Node2D
class_name CardVisuals

@onready var main_sprite = owner.get_node_or_null("Sprite2D")
@onready var skill_slot = owner.find_child("skill_slot", true, false)
@onready var name_label = owner.find_child("LabelName", true, false)
@onready var hp_label = owner.find_child("LabelHealth", true, false)
@onready var damage_label = owner.find_child("LabelDamage", true, false)
@onready var amount_label = owner.find_child("LabelAmount", true, false)

var empty_skill_texture: Texture2D

func _ready() -> void:
	if skill_slot:
		empty_skill_texture = skill_slot.texture

func update_view(card_id,data: Dictionary,location):
	if name_label: name_label.text = data.get("name", "Unknown")
	if hp_label: hp_label.text = str(data.get("health", 0))
	if damage_label: damage_label.text = str(data.get("damage", 0))
	
	if amount_label and location == "all_deck":
		var amount = Global.all_players_cards.get(card_id, 0)
		amount_label.text = str(amount) if amount > 0 else ""
	
	if main_sprite and data.get("texture"):
		main_sprite.texture = data["texture"]
		main_sprite.show()
	
	# Відображення текстури скіла, якщо вона є в даних
	if skill_slot:
		if data.has("skill_texture") and data["skill_texture"]:
			skill_slot.texture = data["skill_texture"]
			skill_slot.show()
		elif location == "hand":
			skill_slot.texture = empty_skill_texture
			skill_slot.show()
		else:
			skill_slot.hide()

func play_damage_animation():
	if main_sprite:
		var tween = create_tween()
		tween.tween_property(main_sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(main_sprite, "modulate", Color.WHITE, 0.1)
