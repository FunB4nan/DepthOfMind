extends Chip

func activate():
	get_parent().get_parent().addAction("attack")
	super()
