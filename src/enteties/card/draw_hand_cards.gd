extends Node

var card_scene = preload("res://scenes/card.tscn")
var CardDB = preload("res://src/enteties/card/card_list.gd").new()

func instantiate_hand_cards(hand_node, card_deck, source):
	var slots = hand_node.get_children()
	var cards = []

	if card_deck is Dictionary:
		cards = card_deck.keys()
	else:
		cards = card_deck
		
	for slot in slots:
		for child in slot.get_children():
			child.queue_free()
			
	for i in range(slots.size()):
		if i >= cards.size():
			break
			
		var card_key = cards[i]
		if card_key != "" and card_key in CardDB.cards:
			var slot = slots[i]
			var card_instance = card_scene.instantiate()
			var current_skill = ""
			if Global.hand_players_skills[i] != "" and source != "all_deck":
				current_skill = Global.hand_players_skills[i]
			slot.add_child(card_instance)
			card_instance.setup(card_key, CardDB.cards[card_key], source, i, Global.can_be_interractable, current_skill)
 
