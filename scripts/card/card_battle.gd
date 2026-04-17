extends Node2D

const CARDS_ON_BOARD = 4
const MAX_DECK_SIZE = 8
const TIME = 0.2
const GLOBAL_TIME = 0.5

var turn = "player"

var CardDB = preload("res://scripts/card/card_list.gd").new()
var SkillDB = preload("res://scripts/skills/skills_list.gd").new()

var curr_stats_player = []
var curr_stats_enemy = []

var enemy_cards = ["S","S","S","S","S","A","A","warrior"]
var player_cards = Global.hand_players_cards

var hand_enemys_skills = ["+1_damage","+1_damage","","","","","",""]

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
		curr_stats_player.append({
			"name":CardDB.cards[player_cards[index]],
			"damage":stats.damage,
			"health":stats.health,
			"skill":Global.hand_players_skills[index],
			"is_alive":true
			})
	for index in range(MAX_DECK_SIZE):
		var stats = CardDB.cards[enemy_cards[index]]
		curr_stats_enemy.append({
			"name":CardDB.cards[enemy_cards[index]],
			"damage":stats.damage,
			"health":stats.health,
			"skill":hand_enemys_skills[index],
			"is_alive":true
			})
		
func is_deck_updated(card_deck, is_player):
	var deck = player_cards if is_player else enemy_cards
	if card_deck != deck:
		return true
	return false
	
func _ready() -> void:
	$enemy_cards_label.text = "enemys cards left:  %s" % [enemy_cards.size()]
	
	copy_updated_deck(enemy_cards_updated,false)
	copy_updated_deck(player_cards_updated,true)
	
	curr_stats_initialize()	# Спочатку ініціалізуємо статі
	instantiate_hand_cards() # Потім створюємо карти, які вже можуть брати ці статі
	
	Global.can_interact = false
	await get_tree().create_timer(GLOBAL_TIME).timeout
	start_battle()

func instantiate_hand_cards():
	var slots = $hand_cards.get_children()
	# Ворожі карти (перші 4 на полі)
	for i in range(0,4):
		var card = enemy_cards[i]	
		var slot = slots[i]
		var card_instance = card_scene.instantiate()	
		card_instance.setup(CardDB.cards[card], curr_stats_enemy[i].skill)
		slot.add_child(card_instance)
		enemy_card_instances.append(card_instance) 
		
	# Ворожі карти (наступні 4 в запасі)
	for i in range(4,8):
		var card = enemy_cards[i]	
		var slot = slots[i]
		var card_instance = card_scene.instantiate()
		card_instance.setup(CardDB.cards[card], curr_stats_enemy[i].skill)
		slot.add_child(card_instance)
		enemy_card_instances.append(card_instance) 
		
	var player_index = 0
	# Гравці (слоти з 8 по 15)
	for i in range(8,16):
		var card = player_cards[player_index]	
		var slot = slots[i]
		var card_instance = card_scene.instantiate()
		card_instance.setup(CardDB.cards[card], curr_stats_player[player_index].skill)
		slot.add_child(card_instance)
		player_card_instances.append(card_instance) 
		player_index += 1

var index = 0
var index_2 = 0
func move_cards_left(card_deck, card_instances, stats_deck, is_player):
	var slots = $hand_cards.get_children()
	var moved_card_deck = []
	var new_card_instances = []
	var moved_stats = []
	var deleted_cards_stats = []
	
	for i in range(card_deck.size()):
		print(stats_deck[i])
		if stats_deck[i].is_alive:
			moved_card_deck.append(card_deck[i])
			new_card_instances.append(card_instances[i])
			moved_stats.append(stats_deck[i])
		else:
			deleted_cards_stats.append(stats_deck[i])
			
	while moved_card_deck.size() < 8:
		moved_card_deck.append("")
		new_card_instances.append(null)
	
	var index = MAX_DECK_SIZE-len(deleted_cards_stats)
	while index < 8:
		moved_stats.append(stats_deck[index])
		index+=1
	
	while moved_stats.size() < MAX_DECK_SIZE:
		moved_stats.append({"is_alive": false})
	
	for i in range(0, MAX_DECK_SIZE):
		card_deck[i] = moved_card_deck[i]
		card_instances[i] = new_card_instances[i]
		stats_deck[i] = moved_stats[i]
	
	var player_idx = 0
	if card_deck == enemy_cards:
		for i in range(0, MAX_DECK_SIZE):
			var card = card_instances[i]
			var slot = slots[i]
			if card != null:
				if card.get_parent():
					card.get_parent().remove_child(card)
				slot.add_child(card)
	else:
		for i in range(8, 16):
			var card = card_instances[player_idx]
			var slot = slots[i]
			if card != null:
				if card.get_parent():
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

func use_skill_spell(attacker_card_stat,deffender_card_stat,att_idx,dff_idx,skill,stats):
	if skill == "" or !SkillDB.skills.has(skill):
		return
		
	var ability = SkillDB.skills[skill].ability
	
	match skill:
		"+1_damage":
			attacker_card_stat[att_idx].damage += ability.attack
		"+5_hp":
			attacker_card_stat[att_idx].health += ability.heal
		"-1_hp_enemy":
			deffender_card_stat[dff_idx].health += ability.kill

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

	var attacker_skill = attacker_stats[attacker_idx].skill
	
	use_skill_spell(attacker_stats, defender_stats, attacker_idx, defender_idx, attacker_skill,attacker_stats)
	
	attacker.set_stat_script.stat(attacker_stats[attacker_idx].damage, attacker.damage_display)
	attacker.set_stat_script.stat(attacker_stats[attacker_idx].health, attacker.health_display)
	await get_tree().create_timer(0.2).timeout
	
	attacker.z_index = 100
	var tween = create_tween()
	tween.tween_property(attacker, "global_position", attack_target, TIME).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	defender_stats[defender_idx].health -= attacker_stats[attacker_idx].damage
	defender.set_stat_script.stat(defender_stats[defender_idx].health,defender.health_display)
	
	if defender_stats[defender_idx].health <= 0:
		defender_cards[defender_idx] = ""
		defender.queue_free()
		defender_instaces[defender_idx] = null
		defender_stats[defender_idx].is_alive = false
		
	# Плавне повернення назад
	var return_tween = create_tween()
	return_tween.tween_property(attacker, "global_position", original_pos, TIME).set_trans(Tween.TRANS_SINE)
	await return_tween.finished
	
	attacker.z_index = 20
		
func card_battle():
	var is_player = (turn == "player")
	var attacker_stats = curr_stats_player if is_player else curr_stats_enemy
	var attacker_cards = player_cards if is_player else enemy_cards
	var defender_cards = enemy_cards if is_player else player_cards
	
	for i in range(4):
		if attacker_stats[i].is_alive == false:
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
		
		await get_tree().create_timer(GLOBAL_TIME).timeout
		turn = "enemy" if turn == "player" else "player"
		await get_tree().create_timer(GLOBAL_TIME).timeout
