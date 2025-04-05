extends Action

func _ready() -> void:
	value = 2

func act():
	if target != null:
		target.heal(value)
		await get_parent().get_parent().toTarget(target)
	super()
