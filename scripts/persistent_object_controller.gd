class_name PersistentObjectController

static var persistent_objects_dict := {}
static var current_level_name: String:
	get: return level_controller.active_level_data.level_name
static var level_controller: LevelController

#TODO threat path renaming
static func register_persistent(persistent_node: Node, level_name: String = current_level_name):
	if not persistent_node.is_in_group("persistent"):
		persistent_node.add_to_group("persistent")
	if not level_name in persistent_objects_dict:
		return
	persistent_node.tree_exited.connect(func():
			if level_controller.level_state == LevelController.LevelState.ACTIVE and level_name == current_level_name:
				persistent_objects_dict[level_name].erase(persistent_node.name))
	persistent_objects_dict[level_name][persistent_node.name] = pack_node(persistent_node)

static func pack_node(node: Node) -> PackedScene:
	for child in node.get_children():
		child.owner = node
	var packed_node = PackedScene.new()
	packed_node.pack(node)
	return packed_node
