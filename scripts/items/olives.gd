extends Item

func _on_use(player: Player):
	player.max_health -= 10
