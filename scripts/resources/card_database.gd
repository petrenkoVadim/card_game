extends Resource
class_name CardDatabase

@export var all_cards: Array[CardData] = []

func get_card_by_id(id: String) -> CardData:
	for card in all_cards:
		if card.card_id == id:
			return card
	return null
