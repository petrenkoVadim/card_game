extends Node
class_name CardData

var stats: Dictionary = {
	"id": "",
	"damage": 0,
	"health": 0,
	"max_health": 0,
	"is_alive": true,
	"skill": "Unknown",
	"texture": null,
	"skill_texture":null
}

func setup(base_data: Dictionary):
	for key in base_data.keys():
		if stats.has(key):
			stats[key] = base_data[key]
	
	if stats.has("health"):
		stats["max_health"] = stats["health"]

func take_damage(amount: int) -> bool:
	stats["health"] -= amount
	if stats["health"] <= 0:
		stats["health"] = 0
		stats["is_alive"] = false
	return not stats["is_alive"]
