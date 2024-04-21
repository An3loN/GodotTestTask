extends Item

func _picked_up(player: Player):
	on_use = func(player: Player):
		player.max_health -= 10
	super(player)
