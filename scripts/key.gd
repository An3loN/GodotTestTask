class_name Key
extends Pickupable

func _picked_up(player: Player):
	player.keys += 1
