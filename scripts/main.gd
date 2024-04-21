extends Node2D

@export var start_level_name: String
@export var player_character_scene: PackedScene
@export var camera_controller: CameraController
@export var hud_controller: HudController
@export var level_container: Node2D
@export var levels_data_container: LevelsDataContainer

@onready var level_controller := LevelController.new(
		camera_controller,
		levels_data_container,
		hud_controller,
		level_container,
		player_character_scene)

func _ready():
	hud_controller.level_controller = level_controller
	level_controller.set_level(start_level_name)
	
