extends Node2D

var draw_cards_script = preload("res://src/enteties/card/draw_hand_cards.gd")

func _ready() -> void:
	Global.can_be_interractable = false
	
	for slot in $hand_cards.get_children():
		for child in slot.get_children():
			child.queue_free()

	var drawer = draw_cards_script.new()
	drawer.instantiate_hand_cards($hand_cards, Global.hand_players_cards, "main")

func _on_battle_button_pressed() -> void:
	Global.can_be_interractable = true
	get_tree().change_scene_to_file("res://scenes/battle_scene/battle_deck.tscn")
	
func _on_card_deck_pressed() -> void:
	Global.can_be_interractable = true
	get_tree().change_scene_to_file("res://scenes/arsenal_scene/arsenal_board.tscn")
