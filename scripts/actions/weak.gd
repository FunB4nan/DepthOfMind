extends Action

func _ready() -> void:
	value = 1

func act(repeats : int):
	if target != null:
		await get_parent().get_parent().toTarget(target)
		Global.camera.shake(200,0.1,300)
		await target.weak(value)
		await get_parent().get_parent().fromTarget()
	super(repeats)
