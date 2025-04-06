extends Action

func act(repeats : int):
	if target != null:
		await get_parent().get_parent().toTarget(get_parent().get_parent())
		Global.main.addEnemy("slime")
		await get_parent().get_parent().fromTarget()
	super(repeats)
