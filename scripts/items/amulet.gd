extends Item

func _on_pick_up(player: Player):
	player.health -= 9
	player.max_health += 1

func _on_drop(player: Player):
	player.max_health -= 1
