extends Chip

func activate():
	parent.dmg += 2
	parent.update()
	await get_tree().create_timer(0.01).timeout
	super()
