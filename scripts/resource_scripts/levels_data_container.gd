class_name LevelsDataContainer
extends Resource

@export var levels_data: Array[LevelData]
var _levels_dict: Dictionary
var levels_dict: Dictionary:
	get = get_dict

func get_dict() -> Dictionary:
	if _levels_dict:
		return _levels_dict
	_levels_dict = {}
	for level_data in levels_data:
		_levels_dict[level_data.level_name] = level_data
	return _levels_dict
