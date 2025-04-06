extends Action

func act():
	value = get_parent().get_parent().dmg
	if target != null:
		await get_parent().get_parent().toTarget(target)
		Global.camera.shake(200,0.1,300)
		await target.getHit(value)
		await get_parent().get_parent().fromTarget()
	super()
