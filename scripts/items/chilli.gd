extends Item

func _on_use(player: Player):
	player.health -= 1
