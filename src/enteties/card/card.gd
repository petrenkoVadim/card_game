extends Node2D

@onready var data: CardData = $Data
@onready var visuals: CardVisuals = $Visuals
@onready var input: CardInput = $InputHandler

signal right_clicked(id, skill_id)
signal card_hovered

var source_name
var card_name
var card_index
var is_can_interract

func _ready():
	if input:
		input.card_clicked.connect(_on_card_clicked)
		input.card_right_clicked.connect(_on_card_right_clicked)
		input.card_hovered.connect(_on_howered_card)

var SkillDB = preload("res://src/enteties/skills/skills_list.gd").new()
var skill_scene = preload("res://scenes/skill.tscn")

func setup(card_id: String, base_data: Dictionary, source, card_idx, can_be_ckicked, skill_id: String = ""):
	source_name = source
	card_name = card_id
	card_index = card_idx
	is_can_interract = can_be_ckicked
	
	#data.stats["skill"] = skill_id	
	data.stats["id"] = card_id
	
	if skill_id != "" and skill_id in SkillDB.skills:
		var skill_instance = skill_scene.instantiate()
		skill_instance.setup(skill_id, SkillDB.skills[skill_id],0)
		data.stats["skill"] = skill_instance.data.stats
		data.stats["skill_texture"] = SkillDB.skills[skill_id]["texture"]
		
	data.setup(base_data)
	visuals.update_view(card_name,data.stats,source_name)

func _on_card_clicked():
	if Global.can_be_interractable:
		Signals.card_clicked.emit(data.stats, source_name, card_index)
		print("Карту обрано: ", data.stats["id"])

func _on_card_right_clicked():
	right_clicked.emit(data.stats["skill"])
	print("Запит біографії: ", data.stats["id"])

func _on_howered_card():
	print(true)

func apply_damage(amount: int):
	var is_dead = data.take_damage(amount)
	visuals.update_view(card_name,data.stats,source_name)
	visuals.play_damage_animation()
	
	if is_dead:
		queue_free()
