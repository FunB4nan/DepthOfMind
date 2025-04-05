extends Action

func act():
	value = get_parent().get_parent().dmg
	var targets
	if Global.main.turn == "player":
		targets = "enemies"
	else:
		targets = "team"
	for t in Global.main.getCardSlot(targets).get_children():
		t.getHit(value)
		await get_parent().get_parent().toTarget(t)
	super()
