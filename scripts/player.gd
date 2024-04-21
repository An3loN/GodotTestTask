class_name Player
extends CharacterBody2D

signal died
signal health_changed(new_health: int)
signal max_health_changed(new_max_health: int)
signal keys_changed(new_keys: int)

@export var speed := 30.0
@export var character: Character
@export var _health := 90
var health: int: 
	set(value):
		set_health(value)
	get:
		return _health
@export var _max_health := 100
var max_health: int:
	set(value):
		set_max_health(value)
	get:
		return _max_health
@export var _keys := 0
var keys: int:
	set(value):
		set_keys(value)
	get:
		return _keys
@export var input_provider: PlayerInputProvider
@export var collision_shape: CollisionShape2D
@onready var data_provider = PersistentDataProvider.new(
		_get_persistent_data,
		_set_persistent_data,
		"player")
var requested_controllers = ["HudController"]
var hud_controller: HudController
var active_interactives: Array[Interactive] = []
var _move_direction = Vector2.ZERO

func _ready():
	add_to_group("controller_requesters")
	input_provider.moved.connect(set_move_direction)
	input_provider.interacted.connect(interact)

func _physics_process(_delta):
	velocity = _move_direction * speed
	move_and_slide()

func pick_up_item(_item_data: ItemData) -> void:
	pass

func set_move_direction(new_move_direction: Vector2) -> void:
	_move_direction = new_move_direction
	if _move_direction == Vector2.ZERO:
		return
	if absf(_move_direction.x) > absf(_move_direction.y):
		if _move_direction.x > 0:
			character.watch_direction = Character.WatchDirection.RIGHT
		else:
			character.watch_direction = Character.WatchDirection.LEFT
	else:
		if _move_direction.y < 0:
			character.watch_direction = Character.WatchDirection.UP
		else:
			character.watch_direction = Character.WatchDirection.DOWN

func interact() -> void:
	if len(active_interactives) > 0:
		active_interactives[0].activate()

func on_interactives_changed() -> void:
	hud_controller.set_interaction_label_visible(len(active_interactives) > 0)

func add_interactive(interactive: Interactive):
	if not interactive in active_interactives:
		active_interactives.append(interactive)
		on_interactives_changed()

func remove_interactive(interactive: Interactive):
	if interactive in active_interactives:
		active_interactives.erase(interactive)
		on_interactives_changed()

func die():
	died.emit()

func set_health(new_health: int) -> void:
	_health = new_health if new_health <= max_health else max_health
	health_changed.emit(health)

func set_max_health(new_max_health: int) -> void:
	_max_health = new_max_health
	health = health
	max_health_changed.emit(max_health)

func set_keys(new_keys: int) -> void:
	_keys = new_keys
	keys_changed.emit(keys)

func set_input_enabled(value: bool) -> void:
	input_provider.enabled = value

func _get_persistent_data() -> PlayerPersistentData:
	return PlayerPersistentData.new(health, max_health, keys)

func _set_persistent_data(data: PlayerPersistentData) -> void:
	_health = data.health
	_max_health = data.max_health
	_keys = data.keys
