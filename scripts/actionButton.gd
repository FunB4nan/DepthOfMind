extends Button

class_name ActionButton

var actionName : String = "attack"
var initialPos : Vector2 = Vector2.ZERO

func _ready() -> void:
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://sfx/Abstract.mp3")
	sound.bus = "sfx"
	add_child(sound)
	showMe(initialPos)
	text = tr(actionName)
	custom_minimum_size = Vector2(200,20)
	pressed.connect(actionPressed)
	mouse_entered.connect(hover)

func hover():
	get_child(0).play()

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
