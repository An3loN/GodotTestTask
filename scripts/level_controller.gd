class_name LevelController

enum LevelState {ENTERING, ACTIVE, EXITING}

var camera_controller: CameraController
var player_character_scene: PackedScene
var levels_data_container: LevelsDataContainer
var hud_controller: HudController
var level_container_node: Node2D
var active_level_data: LevelData
var active_level: Level
var player: Player
var level_state := LevelState.ENTERING

func _init(
		i_camera_controller: CameraController,
		i_levels_data_container: LevelsDataContainer,
		i_hud_controller: HudController,
		i_level_container: Node2D,
		i_player_character_scene: PackedScene):
	camera_controller = i_camera_controller
	levels_data_container = i_levels_data_container
	hud_controller = i_hud_controller
	level_container_node = i_level_container
	player_character_scene = i_player_character_scene
	PersistentDataController.level_controller = self
	PersistentObjectController.level_controller = self

func set_level(level_name: String) -> void:
	if not level_name in levels_data_container.levels_dict:
		printerr("No level named %s" % level_name)
		return
	var spawn_tag = "default"
	if active_level_data:
		level_state = LevelState.EXITING
		spawn_tag = active_level_data.level_name
		_save_all_persistent()
		PersistentDataController.save_all_providers()
		PersistentDataController.clear_providers()
		active_level.queue_free()
	level_state = LevelState.ENTERING
	active_level_data = levels_data_container.levels_dict[level_name] as LevelData
	PersistentDataController.current_level_name = active_level_data.level_name
	active_level = active_level_data.level_scene.instantiate() as Level
	level_container_node.add_child(active_level)
	player = active_level.spawn_character(player_character_scene, spawn_tag) as Player
	_provide_dependencies()
	camera_controller.target = player
	_instantiate_persistent_objects()
	PersistentDataController.load_all_providers()
	hud_controller.initialize_level(active_level, player)
	level_state = LevelState.ACTIVE

func set_player_input_enabled(value: bool) -> void:
	player.set_input_enabled(value)

func _provide_dependencies():
	for requester in active_level.get_tree().get_nodes_in_group("controller_requesters"):
		if not requester.get_property_list().any(func(property_dict):
					return property_dict["name"] == "requested_controllers"):
			printerr("%s has no requested_controllers" % requester)
		for requested_controller in requester.requested_controllers:
			match requested_controller:
				"LevelController":
					requester.level_controller = self
				"HudController":
					requester.hud_controller = hud_controller
				_:
					printerr("No such controller registered in level_controller as %s: " % requested_controller)

func _save_all_persistent():
	for persistent_node in active_level.get_tree().get_nodes_in_group("persistent"):
		if active_level.is_ancestor_of(persistent_node):
			PersistentObjectController.save_node(persistent_node)

func _instantiate_persistent_objects():
	if not active_level_data.level_name in PersistentObjectController.persistent_objects_dict:
		PersistentObjectController.persistent_objects_dict[active_level_data.level_name] = {}
		for persistent_node in active_level.get_tree().get_nodes_in_group("persistent"):
			if active_level.is_ancestor_of(persistent_node):
				PersistentObjectController.register_persistent(persistent_node, active_level_data.level_name)
				PersistentObjectController.save_node(persistent_node)
				persistent_node.free()
		var packed_level = PackedScene.new()
		packed_level.pack(active_level)
		active_level_data.level_scene = packed_level
		print(PersistentObjectController.persistent_objects_dict)
	for name in PersistentObjectController.persistent_objects_dict[active_level_data.level_name]:
		var packed_node := PersistentObjectController.persistent_objects_dict\
				[active_level_data.level_name][name] as PackedScene
		active_level.add_child(packed_node.instantiate())
