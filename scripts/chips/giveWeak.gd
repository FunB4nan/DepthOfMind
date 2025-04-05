extends Chip

func activate():
	get_parent().get_parent().addAction("weak")
	super()
