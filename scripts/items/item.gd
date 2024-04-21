class_name Item
extends Pickupable

@export var sprite_renderer: Sprite2D
@export var item_data := ItemData.new()
@export var usable := true

func _picked_up(player: Player):
	item_data.item_icon = sprite_renderer.texture
	var packed_item = PackedScene.new()
	packed_item.pack(self)
	item_data.item_scene = packed_item
	item_data.on_pick_up = _on_pick_up
	item_data.on_use = _on_use
	item_data.on_drop = _on_drop
	player.pick_up_item(item_data)
	_on_pick_up(player)
	# FIXME
	_on_use(player)

func _on_pick_up(_player: Player) -> void:
	pass

func _on_use(_player: Player) -> void:
	pass

func _on_drop(_player: Player) -> void:
	pass
