extends Node
class_name SkillData

var stats: Dictionary = {
	"id": "",
	"name": "Unknown",
	"ability": {},
	"texture": null,
	"amount": 0
}

func setup(base_data: Dictionary):
	for key in base_data.keys():
		if stats.has(key):
			stats[key] = base_data[key]

func get_ability_type():
	if stats["ability"].is_empty():
		return "none"
	return stats["ability"].keys()[0]

func get_ability_value():
	var type = get_ability_type()
	if type == "none":
		return 0
	return stats["ability"][type]
