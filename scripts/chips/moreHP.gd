extends Chip

func activate():
	parent.maxHp += 4
	parent.hp += 4
	parent.update()
	await get_tree().create_timer(0.01).timeout
	super()
