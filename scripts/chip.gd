extends DragableObject

class_name Chip

signal chipActivated

@export var title = "giveAttackAll"
var used = false
@onready var parent = get_parent().get_parent()

func _ready() -> void:
	super()
	if parent is CharacterCard:
		activate()

func activate():
	await get_tree().create_timer(0.01).timeout
	chipActivated.emit()

func _input(event: InputEvent) -> void:
	super(event)
	if event is InputEventMouseButton:
		if dragPos != position && event.is_released() && !used && mouseInside:
			var target = Global.main.checkCharacters()
			if target && target.canAddChip():
				$connect.play()
				await $connect.finished
				Global.main.chipPicked.emit()
				target.addChip(title)
