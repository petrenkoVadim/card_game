extends Node

var card_scene = preload("res://scenes/card.tscn")
var CardDB = preload("res://scripts/card/card_list.gd").new()

func card_bio_draw(card_bio,slot,health_bar,damage_bar,skill,bio_menu_node):
	if card_bio == "" or not card_bio in CardDB.cards:
		return
	
	for child in slot.get_children():
		child.queue_free()
	
	var card_instance = card_scene.instantiate()
	var card_data = CardDB.cards[card_bio]
	card_instance.setup(card_data, skill)
	slot.add_child(card_instance)
	
	health_bar.text = str(card_data.health)
	damage_bar.text = str(card_data.damage)
	bio_menu_node.show()
