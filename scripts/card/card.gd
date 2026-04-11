extends Node2D

var card_name
var damage
var health

var number_scene = preload("res://scenes/numbers_stats.tscn")

var damage_display
var health_display
var amount_display

signal card_clicked(id)
signal card_skill_clicked(id)

var card_id = ""
var is_skill_chosing
var skill_list = preload("res://scripts/skills/skills_list.gd").new()
	
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
		$skill_slot.texture = skill_list.skills[skill_id].texture
		$skill_slot.show()
	else:
		$skill_slot.hide()

func setup(data, is_skill = false, location = null, amount = 0, id = "", skill_id = ""):
	if location == "all_deck":
		$skill_slot.hide()
	elif skill_id == "":
		$skill_slot.show()
	else:
		set_skill_slot(skill_id)
		
	is_skill_chosing = is_skill
	# Встановлюємо піксельну фільтрацію для всієї карти (успадковується дітьми)
	self.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$Sprite2D.visible = true 	
	
	self.card_id = id
	card_name = data.name
	damage = data.damage	
	health = data.health

	$LabelName.text = card_name
	$Sprite2D.texture = data.texture
	$Sprite2D.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	damage_display = number_scene.instantiate()
	add_child(damage_display)
	damage_display.position = $LabelDamage.position
	damage_display.set_stat(damage)

	health_display = number_scene.instantiate()
	add_child(health_display)
	health_display.position = $LabelHealth.position
	health_display.set_stat(health)

	if amount > 1:
		amount_display = number_scene.instantiate()
		add_child(amount_display)
		amount_display.position = $LabelAmount.position
		amount_display.z_index = 10  
		amount_display.set_stat(amount)

	# старі label можна сховати
	$LabelDamage.visible = false
	$LabelHealth.visible = false
	$LabelAmount.visible = false
