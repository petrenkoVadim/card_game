extends Node

const PATH = "res://assets/textures/images/cards/"

var cards = {
	"warrior": {
		"name": "Warrior",
		"damage": 5,
		"health": 10,
		"texture": load(PATH + "rohan_warrior.png")
	},
	"A": {
		"name": "A",
		"damage": 14,
		"health": 13,
		"texture": load(PATH + "A.png")
	},
	"S": {
		"name": "S",
		"damage": 4,
		"health": 20,
		"texture": load(PATH + "S.png")
	},
	"B": {
		"name": "B",
		"damage": 2,
		"health": 20,
		"texture": load(PATH + "B.png")
	},
	"V": {
		"name": "V",
		"damage": 5,
		"health": 15,
		"texture": load(PATH + "V.png")
	},
	"K": {
		"name": "K",
		"damage": 8,
		"health": 10,
		"texture": load(PATH + "K.png")
	},
	"M": {
		"name": "M",
		"damage": 7,
		"health": 18,
		"texture": load(PATH + "M.png")
	},
	"O": {
		"name": "O",
		"damage": 5,
		"health": 13,
		"texture": load(PATH + "O.png")
	}
}
