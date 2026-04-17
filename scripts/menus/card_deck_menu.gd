extends Node2D

const MAX_LENGTH_DECK_SIZE = 6

var draw_cards_script = preload("res://scripts/card/draw_hand_cards.gd")
var draw_skills_script = preload("res://scripts/skills/draw_skills.gd")
var skill_scene = preload("res://scenes/skill.tscn")
var card_scene = preload("res://scenes/card.tscn")

var all_avaiable_cards = {}
var all_avaiable_skills = {}

var started_element = 0
var selected_skill_id = ""
var skill_card_chosen_id = "" 
var is_skill_card_chosing = false

func get_cards_hash_map(deck,dict):
	for i in range(0,len(deck)):
		if deck[i] in dict:
			dict[deck[i]] += 1
		else:
			dict[deck[i]] = 1

var slised_dict = {}
func dict_slise(i):
	slised_dict.clear()
	var keys = all_avaiable_cards.keys()
	while i < MAX_LENGTH_DECK_SIZE+i and i < keys.size():
		var key = keys[i]
		slised_dict[key] = all_avaiable_cards[key]
		i += 1

func _on_skill_selected(skill_id):
	selected_skill_id = skill_id 
	is_skill_card_chosing = true
	print("Вибрано навичку: ", skill_id)
	draw_board()

func _on_chosing_skill_card(slot_index):
	Global.hand_players_skills[slot_index] = selected_skill_id
	all_avaiable_skills[selected_skill_id] -= 1
		
	if all_avaiable_skills[selected_skill_id] <= 0:
		all_avaiable_skills.erase(selected_skill_id)
	is_skill_card_chosing = false
	draw_board()
	
func _on_card_clicked(card_id, location, slot_index):
	if location == "all_deck":
		var free_slot = Global.hand_players_cards.find("")
		
		if free_slot == -1:
			return
		if not all_avaiable_cards.has(card_id) or all_avaiable_cards[card_id] <= 0:
			return
		Global.hand_players_cards[free_slot] = card_id
		all_avaiable_cards[card_id] -= 1
		
		if all_avaiable_cards[card_id] <= 0:
			all_avaiable_cards.erase(card_id)
	elif location == "hand_deck":
		if card_id == "":
			return
			
		Global.hand_players_cards[slot_index] = ""
		Global.hand_players_skills[slot_index] = ""
		
		if card_id in all_avaiable_cards:
			all_avaiable_cards[card_id] += 1
		else:
			all_avaiable_cards[card_id] = 1
	draw_board()

@onready var card_slots = $hand_cards.get_children()
func _ready() -> void:
	# Робимо так, щоб текстури були чіткими (Nearest)
	get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	# При розтягуванні вікна все залишається піксельним
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	for slot in range(4,8):
		card_slots[slot].hide()
		
	$hand_deck_up.hide()
	$all_deck_left.hide()
	get_cards_hash_map(Global.all_players_cards,all_avaiable_cards)
	get_cards_hash_map(Global.players_all_skills,all_avaiable_skills)
	draw_board()
	
func draw_board():
	for slot in $hand_cards.get_children():
		for child in slot.get_children():
			child.queue_free()
			
	for slot in $all_avaiable_cards_slots.get_children():
		for child in slot.get_children():
			child.queue_free() 
			
	for slot in $skills_slots.get_children():
		for child in slot.get_children():
			child.queue_free()
	
	print(is_skill_card_chosing)
	visible_buttons()	
	dict_slise(started_element)
	var drawer_card = draw_cards_script.new()
	drawer_card.instantiate_hand_cards($hand_cards,Global.hand_players_cards,is_skill_card_chosing,"hand_deck")
	drawer_card.instantiate_hand_cards($all_avaiable_cards_slots,slised_dict,false,"all_deck")
	
	var drawer_skill = draw_skills_script.new()
	drawer_skill.instantiate_skills(all_avaiable_skills,$skills_slots)

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
	if all_avaiable_cards.size() <= MAX_LENGTH_DECK_SIZE or started_element+MAX_LENGTH_DECK_SIZE >= all_avaiable_cards.size():
		$all_deck_right.hide()
	else:
		$all_deck_right.show()
		
	if started_element <= 0:
		$all_deck_left.hide()
	else:
		$all_deck_left.show()
		
func _on_all_deck_right_pressed() -> void:
	if started_element+1 <= all_avaiable_cards.size()-MAX_LENGTH_DECK_SIZE:
		started_element += 1	
	draw_board()

func _on_all_deck_left_pressed() -> void:
	if started_element-1 >= 0:
		started_element -= 1
	draw_board()
		
func _on_return_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/screen.tscn")
