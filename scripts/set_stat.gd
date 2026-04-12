extends Node

func stat(st, label):
	label.text = str(st)
	label.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
