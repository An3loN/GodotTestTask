extends Item

func _picked_up(player: Player):
	on_use = func(player: Player):
		player.health += 1
	super(player)
