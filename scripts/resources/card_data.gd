extends Resource
class_name CardData
## Це шаблон (креслення) для всіх твоїх карт.
## Після збереження цього скрипту ти зможеш створювати нові карти 
## як окремі файли (.tres) через меню "New Resource".
@export_group("Візуал")
@export var card_name: String = "Назва карти"
@export var card_image: Texture2D # Сюди будеш перетягувати картинку героя
@export_multiline var description: String = "Короткий опис або здібність"
@export_group("Характеристики")
@export var health: int = 1
@export var attack: int = 1
@export_group("Технічне")
@export var card_id: String = "" # Можна використати для унікальних ID
