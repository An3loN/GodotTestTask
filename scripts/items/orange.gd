extends Item

func _on_use(player: Player):
	player.max_health += 1
	player.health += 1	
