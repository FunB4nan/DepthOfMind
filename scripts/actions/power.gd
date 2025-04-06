extends Action

func _ready() -> void:
	value = 1

func act(repeats : int):
	if target != null:
		await get_parent().get_parent().toTarget(target)
		await target.power(value)
		await get_parent().get_parent().fromTarget()
	super(repeats)
