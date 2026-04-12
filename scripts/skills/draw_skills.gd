extends Node

var skill_scene = preload("res://scenes/skill.tscn")
var Global_skills_list = preload("res://scripts/skills/skills_list.gd").new()

func instantiate_skills(all_skills,skill_node):
	var skills_slots = skill_node.get_children()
	var skills = all_skills.keys()
	for i in range(0,skills.size()):
		if skills[i] == "":
			continue
		
		var amount = all_skills[skills[i]]
		var skill_instantiate = skill_scene.instantiate()
		skill_instantiate.setup_skill(Global_skills_list.skills[skills[i]],amount)
		skills_slots[i].add_child(skill_instantiate)
		
		if skill_node.get_parent().has_method("_on_skill_selected"):
			skill_instantiate.connect("skill_clicked", skill_node.get_parent()._on_skill_selected)
			
