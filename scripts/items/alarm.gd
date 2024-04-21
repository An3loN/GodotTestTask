extends Item

func _picked_up(player: Player):
	on_use = func(player: Player):
		House.close_all()
	super(player)
