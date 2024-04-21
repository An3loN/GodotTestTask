class_name HudController
extends Control

@export var message_life_time := 2.0
@export var hp_label: Label
@export var max_hp_label: Label
@export var keys_label: Label
@export var interaction_label: Label
@export var popup_container: Container
@export var message_container: Container
var level_controller: LevelController
var windows: Array[Window]

func initialize_level(_level: Level, player: Player):
	hp_label.text = str(player.health)
	max_hp_label.text = str(player.max_health)
	keys_label.text = str(player.keys)
	player.health_changed.connect(func(new_health): hp_label.text = str(new_health))
	player.max_health_changed.connect(func(new_max_health): max_hp_label.text = str(new_max_health))
	player.keys_changed.connect(func(new_keys): keys_label.text = str(new_keys))

func set_interaction_label_visible(visibility: bool):
	interaction_label.visible = visibility

func show_message(message: String):
	var label = Label.new()
	label.text = message
	message_container.add_child(label)
	var auto_destroy_timer = Timer.new()
	auto_destroy_timer.wait_time = message_life_time
	auto_destroy_timer.autostart = true
	add_child(auto_destroy_timer)
	await auto_destroy_timer.timeout
	label.queue_free()
	auto_destroy_timer.queue_free()

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
	windows.append(window)
	window.popup_centered()
	window.tree_exited.connect(func(): remove_window(window))
	level_controller.set_player_input_enabled(false)

func remove_window(window: Window) -> void:
	if window in windows:
		windows.erase(window)
	if len(windows) == 0:
		on_no_windows_left()

func on_no_windows_left():
	level_controller.set_player_input_enabled(true)
