class_name House
extends StaticBody2D

signal opened_state_changed(is_opened: bool)

static var intantiated_houses: Array[House] = []
static var houses_ids: Array[String]

@export var house_id: String = ""
@export var interior_level_name: String = ""
@export var enter_level_changer: LevelChanger
@export var spawn_point: SpawnPoint
@export var level_changer: LevelChanger
@export var enter_area: Area2D
@export var is_opened := false
var requested_controllers = ["HudController"]
var hud_controller: HudController
@onready var data_provider = PersistentDataProvider.new(
	func(): return HousePersistentData.new(is_opened),
	func(data: HousePersistentData): set_opened(data.is_opened),
	house_id
)

func _init():
	if not self in intantiated_houses:
		intantiated_houses.append(self)
	if house_id != "" and not house_id in houses_ids:
		houses_ids.append(house_id)

func _ready():
	_update_state()
	enter_area.body_entered.connect(on_body_close)
	add_to_group("controller_requesters")
	spawn_point.tag = interior_level_name
	level_changer.target_level_name = interior_level_name

func on_body_close(body: Node2D):
	if is_opened or interior_level_name == "" or house_id == "":
		return
	if body is Player:
		if body.keys > 0:
			hud_controller.accept("Use key?",
					func():
						body.keys -= 1
						set_opened(true),
					func():
						pass)

func _exit_tree():
	if self in intantiated_houses:
		intantiated_houses.erase(self)

func set_opened(i_is_opened: bool) -> void:
	if interior_level_name == "":
		return
	if i_is_opened != is_opened:
		is_opened = i_is_opened
		_update_state()
		opened_state_changed.emit(is_opened)

static func close_all() -> void:
	for house in intantiated_houses:
		house.set_opened(false)
	for other_house_id in houses_ids:
		if not other_house_id in PersistentDataController.data_dict:
			PersistentDataController.data_dict[other_house_id] = HousePersistentData.new(false)
		else:
			PersistentDataController.data_dict[other_house_id].is_opened = false

func _update_state():
	enter_level_changer.set_enabled(is_opened)
