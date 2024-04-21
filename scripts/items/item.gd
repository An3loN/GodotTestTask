class_name Item
extends Pickupable

@export var sprite_renderer: Sprite2D
@export var item_data := ItemData.new()
@export var usable := true
var on_use: Callable = func(_player): pass
var on_drop: Callable = func(_player): pass

func _ready():
	super()
	pickup_condition = func(player: Player):
			return not player.item_storage.is_full

func _picked_up(player: Player):
	item_data.item_icon = sprite_renderer.texture
	item_data.usable = usable
	var packed_item = PackedScene.new()
	packed_item.pack(self)
	item_data.item_scene = packed_item
	item_data.on_pick_up = _on_pick_up
	item_data.on_use = on_use
	item_data.on_drop = on_drop
	player.pick_up_item(item_data)
	_on_pick_up(player)

func _on_pick_up(_player: Player) -> void:
	pass
