extends Action

func act(repeats : int):
	value = get_parent().get_parent().dmg
	if target != null:
		await get_parent().get_parent().toTarget(target)
		Global.camera.shake(200,0.1,300)
		await target.getHit(value)
		get_parent().get_parent().attacked.emit(value)
		await get_parent().get_parent().fromTarget()
	super(repeats)
