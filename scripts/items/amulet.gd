extends Item

func _on_pick_up(player: Player):
	player.health -= 9
	player.max_health += 1

func _picked_up(player: Player):
	on_drop = func(player: Player):
		player.max_health -= 1
	super(player)
