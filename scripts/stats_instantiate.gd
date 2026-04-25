extends Node

var CardDB = preload("res://scripts/card/card_list.gd").new()
var SkillDB = preload("res://scripts/skills/skills_list.gd").new()

func curr_stats_initialize(enemy_cards,hand_enemys_skills):
	var curr_stats_player = []
	var curr_stats_enemy = []
	for index in range(8):
		var stats = CardDB.cards[Global.hand_players_cards[index]]
		curr_stats_player.append({
			"name":CardDB.cards[Global.hand_players_cards[index]].name,
			"damage":stats.damage,
			"health":stats.health,
			"skill":Global.hand_players_skills[index],
			"is_alive":true
			})
	for index in range(8):
		var stats = CardDB.cards[enemy_cards[index]]
		curr_stats_enemy.append({
			"name":CardDB.cards[enemy_cards[index]].name,
			"damage":stats.damage,
			"health":stats.health,
			"skill":hand_enemys_skills[index],
			"is_alive":true
			})
