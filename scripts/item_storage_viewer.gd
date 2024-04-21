class_name ItemStorageViewer
extends Control

signal item_selected(item)

@export var item_buttons_container: Container
@export var buttons_container: Container
@export var item_name_label: Label
@export var item_description_label: Label
@export var item_button_scene: PackedScene
@export var item_action_button_scene: PackedScene
var default_name: String
var default_description: String
var selected_ind := -1

var _target_storage: ItemStorage
var target_storage: ItemStorage:
	get:
		return _target_storage
	set(value):
		_target_storage = value
		if not value.changed.is_connected(update):
			value.changed.connect(update)
		update()

func _ready():
	default_name = item_name_label.text
	default_description = item_description_label.text
	item_selected.connect(on_item_selected)

func on_item_selected(item_data: ItemData) -> void:
	if not item_data:
		item_name_label.text = default_name
		item_description_label.text = default_description
		return
	item_name_label.text = item_data.item_name
	item_description_label.text = item_data.item_description

func update() -> void:
	clear_buttons()
	selected_ind = -1
	item_name_label.text = default_name
	item_description_label.text = default_description
	for item_button in item_buttons_container.get_children():
		item_button.queue_free()
	for i in range(target_storage.capacity):
		var item_button = item_button_scene.instantiate() as Button
		if i < len(target_storage.items):
			item_button.icon = target_storage.items[i].item_icon
		item_buttons_container.add_child(item_button)
		item_button.pressed.connect(func():
				var ind = item_buttons_container.get_children().find(item_button)
				select(ind))

func select(ind: int) -> void:
	selected_ind = ind
	if ind < len(target_storage.items) and ind >= 0:
		var item_data = target_storage.items[ind]
		item_selected.emit(item_data)
		return
	item_selected.emit(null)

func clear_selected() -> void:
	selected_ind = -1

func clear_buttons() -> void:
	for button in buttons_container.get_children():
		button.queue_free()

func get_selected() -> ItemData:
	if selected_ind < len(target_storage.items):
		return target_storage.items[selected_ind]
	return null

func add_button(text: String, action: Callable) -> void:
	var action_button = item_action_button_scene.instantiate() as Button
	action_button.text = text
	action_button.button_down.connect(action)
	buttons_container.add_child(action_button)

