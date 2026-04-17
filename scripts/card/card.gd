extends Node2D

var card_name
var damage
var health

var set_stat_script = preload("res://scripts/set_stat.gd").new()

signal card_clicked(id)
signal card_skill_clicked()

var card_id = ""
var is_skill_chosing
var skill_list = preload("res://scripts/skills/skills_list.gd").new()

var damage_display
var health_display
var amount_display

func _input(event):
	if not is_visible_in_tree() or not Global.can_interact:
		return
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = $Sprite2D.get_local_mouse_position()
		var rect = $Sprite2D.get_rect()
		
		if rect.has_point(mouse_pos):
			if is_skill_chosing == false:
				print("Клікнули по карті: ", card_id)
				emit_signal("card_clicked", card_id)
			else:
				emit_signal("card_skill_clicked")

func set_skill_slot(skill_id):
	if skill_id != "" and skill_id in skill_list.skills:
		$Sprite2D/skill_slot.texture = skill_list.skills[skill_id].texture
		$Sprite2D/skill_slot.show()
	else:
		$Sprite2D/skill_slot.hide()

func setup(data,skill_id, is_skill = false, location = null, amount = 0, id = ""):
	damage_display = $Sprite2D/LabelDamage
	health_display = $Sprite2D/LabelHealth
	amount_display = $Sprite2D/LabelAmount
	
	if location == "all_deck":
		$Sprite2D/skill_slot.hide()
	elif skill_id == "":
		$Sprite2D/skill_slot.show()
	else:
		set_skill_slot(skill_id)
		
	is_skill_chosing = is_skill
	self.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$Sprite2D.visible = true 	
	
	self.card_id = id
	card_name = data.name
	damage = data.damage	
	health = data.health

	$Sprite2D.texture = data.texture
	$Sprite2D.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	$Sprite2D/LabelName.text = card_name
	
	# Налаштування чіткості для всіх Label
	for label in [$Sprite2D/LabelName, $Sprite2D/LabelDamage, $Sprite2D/LabelHealth, $Sprite2D/LabelAmount]:
		label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	set_stat_script.stat(damage, damage_display)
	set_stat_script.stat(health, health_display)

	if amount > 1:
		set_stat_script.stat(amount, amount_display)
