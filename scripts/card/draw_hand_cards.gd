extends Node

var card_scene = preload("res://scenes/card.tscn")
var CardDB = preload("res://scripts/card/card_list.gd").new()

func instantiate_hand_cards(hand_node, card_deck, is_skill_chosing = false, location = "hand_deck",card_bio_id = ""):
	if hand_node == null: 
		return
	
	var slots = hand_node.get_children()
	var keys = []
	if card_deck is Dictionary:
		keys = card_deck.keys()
	
	for i in range(0, slots.size()):
		var slot = slots[i]
		var card_key = ""
		var amount = 0

		if card_deck is Dictionary:
			if i < keys.size():
				card_key = keys[i]
				amount = card_deck[card_key]
		elif i < card_deck.size():
			card_key = card_deck[i]
	
		if card_key != "" and card_key in CardDB.cards:
			var card_instance = card_scene.instantiate()
			
			var current_skill = ""
			if location == "hand_deck":
				if "hand_players_skills" in Global and i < Global.hand_players_skills.size():
					current_skill = Global.hand_players_skills[i]
			
			# Налаштування карти (передаємо skill_id останнім аргументом)
			card_instance.setup(CardDB.cards[card_key], current_skill, is_skill_chosing, location, amount, card_key)
			slot.add_child(card_instance)
			
			# Підключення сигналів
			var parent = hand_node.get_parent()
			if is_skill_chosing:
				if location == "hand_deck" and parent.has_method("_on_chosing_skill_card"):
					card_instance.connect("card_skill_clicked", parent._on_chosing_skill_card.bind(i))
			else:
				if parent.has_method("_on_card_clicked"):
					card_instance.connect("card_clicked", parent._on_card_clicked.bind(location, i))
				if parent.has_method("_on_bio_card_clicked"):
					card_instance.connect("card_bio_id_clicked",parent._on_bio_card_clicked.bind(i))
					
