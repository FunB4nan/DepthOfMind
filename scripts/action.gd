extends Node

class_name Action

signal actionFinished

@export var needOneTarget = true
@export var friendly = false
var target
var value : int

func act():
	actionFinished.emit()
	queue_free()
