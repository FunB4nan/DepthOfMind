extends PanelContainer

class_name TooltipVisual

var object

func _ready() -> void:
	if object != null:
		%discription.text = tr(object.title + "Disc")
