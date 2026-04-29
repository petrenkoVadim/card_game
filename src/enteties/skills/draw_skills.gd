extends Node

var skill_scene = preload("res://scenes/skill.tscn")
var Global_skills_list = preload("res://src/enteties/skills/skills_list.gd").new()

func instantiate_skills(all_skills,skill_node):
	var skills_slots = skill_node.get_children()
	for slot in skills_slots:
		for child in slot.get_children():
			child.queue_free()
			
	var skills = all_skills.keys()
	for i in range(0,skills.size()):
		if skills[i] == "" or i >= skills_slots.size():
			continue
			
		var amount = all_skills[skills[i]]
		
		var skill_instantiate = skill_scene.instantiate()
		skills_slots[i].add_child(skill_instantiate)
		skill_instantiate.setup(skills[i],Global_skills_list.skills[skills[i]],amount)
