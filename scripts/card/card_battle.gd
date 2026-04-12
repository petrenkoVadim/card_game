extends Node2D

const CARDS_ON_BOARD = 4
const MAX_DECK_SIZE = 8
const TIME = 0.1

var turn = "player"

var CardDB = preload("res://scripts/card/card_list.gd").new()

var curr_stats_player = []
var curr_stats_enemy = []

var enemy_cards = ["S","S","S","S","S","A","A","warrior"]
var player_cards = Global.hand_players_cards
var enemy_cards_updated = []
var player_cards_updated = []

var enemy_card_instances = []
var player_card_instances = []

var card_scene = preload("res://scenes/card.tscn")

var rest_y = 0
var rest_x = 250

func copy_updated_deck(deck, is_player):
	var cards = player_cards if is_player else enemy_cards
	for i in range(0, MAX_DECK_SIZE):
		deck.append(cards[i])
	
func curr_stats_initialize():
	curr_stats_player = []
	curr_stats_enemy = []
	for index in range(MAX_DECK_SIZE):
		var stats = CardDB.cards[player_cards[index]]
		curr_stats_player.append([stats.damage, stats.health])
	for index in range(MAX_DECK_SIZE):
		var stats = CardDB.cards[enemy_cards[index]]
		curr_stats_enemy.append([stats.damage, stats.health])
		
func is_deck_updated(card_deck, is_player):
	var deck = player_cards if is_player else enemy_cards
	if card_deck != deck:
		return true
	return false
	
func _ready() -> void:
	$enemy_cards_label.text = "enemys cards left:  %s" % [enemy_cards.size()]
	instantiate_hand_cards()
	Global.can_interact = false
	
	copy_updated_deck(enemy_cards_updated,false)
	copy_updated_deck(player_cards_updated,true)
	
	await get_tree().create_timer(1.0).timeout
	curr_stats_initialize()	
	start_battle()

func instantiate_hand_cards():
	var slots = $hand_cards.get_children()
	for i in range(0,4):
		var card = enemy_cards[i]	
		var slot = slots[i]
		var card_instance = card_scene.instantiate()	
		card_instance.setup(CardDB.cards[card],)
		slot.add_child(card_instance)
		enemy_card_instances.append(card_instance) 
		
	for i in range(4,8):
		var card = enemy_cards[i]	
		var slot = slots[i]
		var card_instance = card_scene.instantiate()
		card_instance.setup(CardDB.cards[card])
		slot.add_child(card_instance)
		enemy_card_instances.append(card_instance) 
		
	var player_index = 0
	for i in range(8,16):
		var card = player_cards[player_index]	
		var slot = slots[i]
		var card_instance = card_scene.instantiate()
		card_instance.setup(CardDB.cards[card])
		slot.add_child(card_instance)
		player_index += 1
		player_card_instances.append(card_instance) 

var index = 0
var index_2 = 0
func move_cards_left(card_deck, card_instances, stats_deck, is_player):
	var slots = $hand_cards.get_children()
	var moved_card_deck = []
	var new_card_instances = []
	var moved_stats = []
	
	for i in range(card_deck.size()):
		if card_deck[i] != "":
			moved_card_deck.append(card_deck[i])
			new_card_instances.append(card_instances[i])
			moved_stats.append(stats_deck[i])
	
	while moved_card_deck.size() < 8:
		moved_card_deck.append("")
		new_card_instances.append(null)
		moved_stats.append([0,0])
	
	for i in range(0, MAX_DECK_SIZE):
		card_deck[i] = moved_card_deck[i]
		card_instances[i] = new_card_instances[i]
		stats_deck[i] = moved_stats[i]
	
	var player_idx = 0
	var enemy_idx = 0
	for i in range(0, MAX_DECK_SIZE):
		if card_deck == enemy_cards:
			var card = card_instances[enemy_idx]
			var slot = slots[i]
			if card != null:
				card.get_parent().remove_child(card)
				slot.add_child(card)
			enemy_idx += 1
	for i in range(8,16):
		if card_deck == player_cards:
			var card = card_instances[player_idx]
			var slot = slots[i]
			if card != null:
				card.get_parent().remove_child(card)
				slot.add_child(card)
			player_idx += 1
			
func get_nearest_first_card(deck):
	var survived_card_pos = []
	for i in range(0,4):
		if deck[i] == "":
			continue
		survived_card_pos.append(i)
	return survived_card_pos
	
func perform_attack(attacker_idx,defender_idx,is_player):
	var attacker_instances = player_card_instances if is_player else enemy_card_instances
	var defender_instaces = enemy_card_instances if is_player else player_card_instances
	var defender_cards = enemy_cards if is_player else player_cards
	var attacker_stats = curr_stats_player if is_player else curr_stats_enemy
	var defender_stats = curr_stats_enemy if is_player else curr_stats_player
	
	var attacker = attacker_instances[attacker_idx]
	var defender = defender_instaces[defender_idx]
	
	if attacker == null or defender == null:
		return
	
	var original_pos = attacker.global_position 
	var attack_target = defender.global_position

	attacker.z_index = 100

	var tween = create_tween()
	tween.tween_property(attacker, "global_position", attack_target, TIME).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	defender_stats[defender_idx][1] -= attacker_stats[attacker_idx][0]
	defender.set_stat_script.stat(defender_stats[defender_idx][1],defender.health_display)
	
	if defender_stats[defender_idx][1] <= 0:
		defender_cards[defender_idx] = ""
		defender.queue_free()
		defender_instaces[defender_idx] = null
		
	# Плавне повернення назад
	var return_tween = create_tween()
	return_tween.tween_property(attacker, "global_position", original_pos, TIME).set_trans(Tween.TRANS_SINE)
	await return_tween.finished
	
	attacker.z_index = 20
		
func card_battle():
	var is_player = (turn == "player")
	var attacker_cards = player_cards if is_player else enemy_cards
	var defender_cards = enemy_cards if is_player else player_cards
	
	for i in range(4):
		if attacker_cards[i] == "":
			continue
			
		var target_idx = i
		
		if defender_cards[i] == "":
			var targets = get_nearest_first_card(defender_cards)
			if targets.size() > 0:
				target_idx = targets[0]
				
		await perform_attack(i,target_idx,is_player)
		
func len_enemy_cards():
	var len = 0
	for card in enemy_cards:
		if card != "":
			len+=1
	return len
 
func is_alive(card_deck):
	for card in card_deck:
		if card != "":
			return true
	return false

func start_battle():
	while is_alive(player_cards) and is_alive(enemy_cards):
		await card_battle()
		
		if is_deck_updated(enemy_cards_updated,false):
			move_cards_left(enemy_cards,enemy_card_instances,curr_stats_enemy,false)
			enemy_cards_updated = []
			copy_updated_deck(enemy_cards_updated,false)
		if is_deck_updated(player_cards_updated,true):
			move_cards_left(player_cards,player_card_instances,curr_stats_player,true)
			player_cards_updated = []
			copy_updated_deck(player_cards_updated,true)
			
		$enemy_cards_label.text = "enemys cards left:  %s" % [len_enemy_cards()]
		
		await get_tree().create_timer(1.0).timeout
		turn = "enemy" if turn == "player" else "player"
		await get_tree().create_timer(1.0).timeout
