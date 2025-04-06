extends Action

func act(repeats : int):
	value = get_parent().get_parent().dmg
	var targets
	if Global.main.turn == "player":
		targets = "enemies"
	else:
		targets = "team"
	for t in Global.main.getCardSlot(targets).get_children():
		await get_parent().get_parent().toTarget(t)
		Global.camera.shake(200,0.1,300)
		await t.getHit(value)
		get_parent().get_parent().attacked.emit(value)
		await get_parent().get_parent().fromTarget()
	super(repeats)
