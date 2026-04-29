extends Node

var main_node = "res://assets/textures/images/skills/"

var skills = {
	"+1_damage":{
		"name":"+1_damage",
		"ability":{"attack":1},
		"texture": load(main_node + "damage_bonus.png")
	},
	"+5_hp":{
		"name":"+5_hp",
		"ability":{"heal":5},
		"texture": load(main_node + "hp_bonus.png")
	},
	"-1_hp_enemy":{
		"name":"-1_hp_enemy",
		"ability":{"kill":-1},
		"texture": load(main_node + "-1_hp_bonus.png")
	}
}
