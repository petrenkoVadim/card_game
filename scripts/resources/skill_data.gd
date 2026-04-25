extends Resource
class_name SkillData

@export var skill_name: String = ""
@export var icon: Texture2D
@export var description: String = ""

@export_group("Effects")
@export var health_change: int = 0
@export var attack_change: int = 0
@export var special_effect: String = "" # Наприклад "kill_enemy", "draw_card"
