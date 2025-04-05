extends Button

class_name ActionButton

var actionName : String = "attack"
var initialPos : Vector2 = Vector2.ZERO

func _ready() -> void:
	showMe(initialPos)
	text = actionName
	custom_minimum_size = Vector2(100,20)
	pressed.connect(actionPressed)

func actionPressed():
	get_parent().actionChoosen.emit()
	get_parent().get_node("actions").add_child(load("res://prefabs/actions/%s.tscn" % actionName).instantiate()) 

func showMe(pos : Vector2):
	var tween = create_tween().bind_node(self)
	tween.tween_property(self, "position", pos, 0.1)
	tween.play()

func hideMe():
	var tween = create_tween().bind_node(self)
	tween.tween_property(self, "position", Vector2.ZERO, 0.1)
	tween.play()
	await tween.finished
	queue_free()
