extends Node

var skills = {
	"+1_damage":{
		"name":"+1_damage",
		"ability":{"attack":1},
		"texture": preload("res://images/skills/damage_bonus.png")
	},
	"+5_hp":{
		"name":"+5_hp",
		"ability":{"heal":5},
		"texture": preload("res://images/skills/hp_bonus.png")
	},
	"-1_hp_enemy":{
		"name":"-1_hp_enemy",
		"ability":{"kill":-1},
		"texture": preload("res://images/skills/-1_hp_bonus.png")
	}
}
