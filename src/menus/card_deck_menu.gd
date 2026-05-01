extends Node2D

const MAX_LENGTH_DECK_SIZE = 6

var draw_cards_script = preload("res://src/enteties/card/draw_hand_cards.gd")
var draw_skills_script = preload("res://src/enteties/skills/draw_skills.gd")
var skill_scene = preload("res://scenes/skill.tscn")
var card_scene = preload("res://scenes/card.tscn")

var started_element = 0
var selected_skill_id
var is_skill_card_chosing = false
var bio_card = ""
var bio_card_skill = ""

var slised_dict = {}

func dict_slise(i):
	slised_dict.clear()
	var keys = Global.all_players_cards.keys()
	while i < MAX_LENGTH_DECK_SIZE+i and i < keys.size():
		var key = keys[i]
		slised_dict[key] = Global.all_players_cards[key]
		i += 1

func _on_skill_selected(skill_id):
	selected_skill_id = skill_id
	Global.players_all_skills[selected_skill_id] -= 1
	if Global.players_all_skills[selected_skill_id] <= 0:
		Global.players_all_skills.erase(selected_skill_id)
	is_skill_card_chosing = true

func apply_skill_to_card(card_idx):
	Global.hand_players_skills[card_idx] = selected_skill_id
	is_skill_card_chosing = false
	selected_skill_id = ""
	draw_hand_cards()
	draw_skills()

func _on_card_clicked(card_data,source,idx):
	if source == "hand":
		if is_skill_card_chosing:
			apply_skill_to_card(idx)
		else:
			Global.hand_players_cards[idx] = ""
			Global.hand_players_skills[idx] = ""
			var arsenal_card_id = card_data["id"]
			if Global.all_players_cards.has(arsenal_card_id):
				Global.all_players_cards[arsenal_card_id] += 1
			else:
				Global.all_players_cards[arsenal_card_id] = 1
		
	elif source == "all_deck":
		var free_slot = Global.hand_players_cards.find("")
		if free_slot == -1:
			return
		Global.hand_players_cards[free_slot] = card_data["id"]
		
		Global.all_players_cards[card_data["id"]] -= 1
		if Global.all_players_cards[card_data["id"]] == 0:
			Global.all_players_cards.erase(card_data["id"])
	draw_all_cards()
	draw_hand_cards()

@onready var card_slots = $hand_cards.get_children()
func _ready() -> void:
	# Робимо так, щоб текстури були чіткими (Nearest)
	get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	# При розтягуванні вікна все залишається піксельним
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	
	Global.can_be_interractable = true
	
	Signals.card_clicked.connect(_on_card_clicked)
	Signals.skill_clicked.connect(_on_skill_selected)
	
	for slot in range(4,8):
		card_slots[slot].hide()
	
	$card_bio.hide()
	$hand_deck_up.hide()
	$all_deck_left.hide()
	
	draw_hand_cards()
	draw_all_cards()
	draw_skills()

func draw_hand_cards():
	for slot in $hand_cards.get_children():
		for child in slot.get_children():
			child.queue_free()
	var drawer_card = draw_cards_script.new()
	drawer_card.instantiate_hand_cards($hand_cards,Global.hand_players_cards,"hand")

func draw_all_cards():
	for slot in $all_avaiable_cards_slots.get_children():
		for child in slot.get_children():
			child.queue_free() 
	visible_buttons()	
	dict_slise(started_element)
	var drawer_card = draw_cards_script.new()
	drawer_card.instantiate_hand_cards($all_avaiable_cards_slots,slised_dict,"all_deck")
func draw_skills():
	for slot in $skills_slots.get_children():
		for child in slot.get_children():
			child.queue_free()
	var drawer_skill = draw_skills_script.new()
	drawer_skill.instantiate_skills(Global.players_all_skills,$skills_slots)

#buttons 
func _on_hand_deck_down_pressed() -> void:
	for slot in range(0,8):
		if slot >= 4:
			card_slots[slot].show()
		else:
			card_slots[slot].hide()
		$hand_deck_up.show()
		$hand_deck_down.hide()
			
func _on_hand_deck_up_pressed() -> void:
	for slot in range(0,8):
		if slot < 4:
			card_slots[slot].show()
		else:
			card_slots[slot].hide()
		$hand_deck_up.hide()
		$hand_deck_down.show()

func visible_buttons():
	if Global.all_players_cards.size() <= MAX_LENGTH_DECK_SIZE or started_element+MAX_LENGTH_DECK_SIZE >= Global.all_players_cards.size():
		$all_deck_right.hide()
	else:
		$all_deck_right.show()
		
	if started_element <= 0:
		$all_deck_left.hide()
	else:
		$all_deck_left.show()
		
func _on_all_deck_right_pressed() -> void:
	if started_element+1 <= Global.all_players_cards.size()-MAX_LENGTH_DECK_SIZE:
		started_element += 1	
	draw_all_cards()

func _on_all_deck_left_pressed() -> void:
	if started_element-1 >= 0:
		started_element -= 1
	draw_all_cards()
		
func _on_return_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/screen.tscn")
