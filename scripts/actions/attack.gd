extends Action

func act():
	value = get_parent().get_parent().dmg
	if target != null:
		target.getHit(value)
		await get_parent().get_parent().toTarget(target)
	super()
