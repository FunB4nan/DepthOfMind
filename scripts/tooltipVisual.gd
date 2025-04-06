extends PanelContainer

class_name TooltipVisual

var object

func _ready() -> void:
	scale = Vector2.ZERO
	if object != null:
		%discription.text = tr(object.title + "Disc")

func customShow():
	show()
	var tween = create_tween().bind_node(self)
	tween.tween_property(self,"scale", Vector2.ONE, 0.1)
	tween.play()

func customHide():
	var tween = create_tween().bind_node(self)
	tween.tween_property(self,"scale", Vector2.ZERO, 0.1)
	tween.play()
	await tween.finished
	hide()
