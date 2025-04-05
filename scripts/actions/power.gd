extends Action

func _ready() -> void:
	value = 1

func act():
	if target != null:
		target.power(value)
		await get_parent().get_parent().toTarget(target)
	super()
