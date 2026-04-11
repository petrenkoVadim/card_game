extends Node2D

var numbers = preload("res://images/numbers.png")
var num_widht = 5
var num_height = 9

func set_stat(value):
	for child in get_children():
		child.queue_free()
		
	var stat = str(value)
	for i in range(stat.length()):
		var digit = int(stat[i])
		
		var sprite = Sprite2D.new()
		sprite.texture = numbers
		sprite.region_enabled = true
		sprite.region_rect = Rect2(digit*num_widht+digit,0,num_widht,num_height)
		
		# Встановлюємо піксельну фільтрацію для кожної цифри
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		sprite.position.x = i * (num_widht+1)
		
		add_child(sprite)
	
	
