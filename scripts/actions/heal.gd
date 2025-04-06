extends Action

func _ready() -> void:
	value = 2

func act(repeats : int):
	if target != null:
		await get_parent().get_parent().toTarget(target)
		await target.heal(value)
		await get_parent().get_parent().fromTarget()
	super(repeats)
