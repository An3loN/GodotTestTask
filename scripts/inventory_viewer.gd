class_name InventoryViewer
extends ItemStorageViewer

var player: Player

func _ready():
	super()
	item_selected.connect(set_item_buttons)

func set_item_buttons(item_data: ItemData):
	clear_buttons()
	if not item_data:
		clear_buttons()
		return
	if item_data.usable:
		add_button("Use", func():
					item_data.on_use.call(player)
					target_storage.remove_item(selected_ind))
	add_button("Drop", func():
				item_data.on_drop.call(player)
				target_storage.remove_item(selected_ind)
				player.instantiate_nearby(item_data.item_scene))
