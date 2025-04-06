extends Chip

func _ready() -> void:
	if parent is CharacterCard:
		parent.attacked.connect(vampire)
	super()

func vampire(value : int):
	parent.heal(value)
