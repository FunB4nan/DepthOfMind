extends Node

class_name Action

signal actionFinished

@export var needOneTarget = true
@export var friendly = false
var target
var value : int

func act(repeats : int):
	await get_tree().create_timer(0.01).timeout
	actionFinished.emit()
	if repeats == get_parent().get_parent().actionRepeats - 1:
		queue_free()
