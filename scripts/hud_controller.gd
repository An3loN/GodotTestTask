class_name HudController
extends Control

@export var message_life_time := 2.0
@export var hp_label: Label
@export var max_hp_label: Label
@export var keys_label: Label
@export var interaction_label: Label
@export var popup_container: Container
@export var message_container: Container
@export var inventory_viewer: InventoryViewer
var level_controller: LevelController
var input_blockators: Array[Node]

func initialize_level(_level: Level, player: Player):
	input_blockators = []
	inventory_viewer.visible = false
	inventory_viewer.player = player
	hp_label.text = str(player.health)
	max_hp_label.text = str(player.max_health)
	keys_label.text = str(player.keys)
	player.health_changed.connect(func(new_health): hp_label.text = str(new_health))
	player.max_health_changed.connect(func(new_max_health): max_hp_label.text = str(new_max_health))
	player.keys_changed.connect(func(new_keys): keys_label.text = str(new_keys))
	inventory_viewer.target_storage = player.item_storage

func set_interaction_label_visible(visibility: bool):
	interaction_label.visible = visibility

func show_message(message: String, color: Color = Color.WHITE):
	var label = Label.new()
	label.text = message
	label.label_settings = LabelSettings.new()
	label.label_settings.font_color = color
	message_container.add_child(label)
	var auto_destroy_timer = Timer.new()
	auto_destroy_timer.wait_time = message_life_time
	auto_destroy_timer.autostart = true
	add_child(auto_destroy_timer)
	await auto_destroy_timer.timeout
	label.queue_free()
	auto_destroy_timer.queue_free()

func toggle_inventory():
	inventory_viewer.visible = not inventory_viewer.visible
	var visibility = inventory_viewer.visible
	if visibility:
		inventory_viewer.clear_selected()
		inventory_viewer.update()
		add_input_blockator(inventory_viewer)
	else:
		remove_input_blockator(inventory_viewer)

func accept(text: String, on_accept: Callable, on_cancel: Callable) -> void:
	var accept_window = AcceptDialog.new()
	accept_window.title = text
	register_window(accept_window)
	accept_window.add_cancel_button("Cancel")
	accept_window.confirmed.connect(func():
			on_accept.call()
			accept_window.queue_free())
	accept_window.canceled.connect(func():
			on_cancel.call()
			accept_window.queue_free())

func register_window(window: Window) -> void:
	popup_container.add_child(window)
	add_input_blockator(window)
	window.popup_centered()
	window.tree_exited.connect(func(): remove_input_blockator(window))

func add_input_blockator(input_blockator: Node) -> void:
	input_blockators.append(input_blockator)
	level_controller.set_player_input_enabled(false)

func remove_input_blockator(input_blockator: Node) -> void:
	if input_blockator in input_blockators:
		input_blockators.erase(input_blockator)
	if len(input_blockators) == 0:
		on_no_input_blockators_left()

func on_no_input_blockators_left():
	level_controller.set_player_input_enabled(true)
