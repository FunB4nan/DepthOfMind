extends DragableObject

class_name Chip

signal chipActivated

@export var title = "giveAttackAll"
var used = false

func activate():
	chipActivated.emit()

func _input(event: InputEvent) -> void:
	super(event)
	if event is InputEventMouseButton:
		if dragPos != position && event.is_released() && !used && mouseInside:
			var target = Global.main.checkCharacters()
			if target && target.canAddChip():
				Global.main.chipPicked.emit()
				target.addChip(title)
