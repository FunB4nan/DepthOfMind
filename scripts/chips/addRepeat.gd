extends Chip

func activate():
	parent.actionRepeats += 1
	await get_tree().create_timer(0.01).timeout
	super()
