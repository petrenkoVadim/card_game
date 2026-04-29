extends Node2D

@onready var data: SkillData = $Data
@onready var visuals: SkillVisuals = $Visual
@onready var input: SkillInput = $skill_input

func _ready():
	if input:
		input.skill_clicked.connect(_on_skill_clicked)

func setup(skill_id: String, base_data: Dictionary, amount):
	if data == null:
		data = $Data
	if visuals == null:
		visuals = $Visual
	data.setup(base_data)
	data.stats["id"] = skill_id
	data.stats["amount"] = amount
	visuals.update_view(data.stats)

func _on_skill_clicked():
	Signals.skill_clicked.emit(data.stats["name"])
	print("Скіл обрано: ", data.stats["name"])
