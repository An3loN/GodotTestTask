class_name LevelChanger
extends Area2D

@export var target_level_name: String
var requested_controllers = ["LevelController"]
var level_controller: LevelController
var enabled := true

func _ready():
	add_to_group("controller_requesters")
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	if body is Player:
		level_controller.set_level.call_deferred(target_level_name)

func set_enabled(value: bool) -> void:
	enabled = value
