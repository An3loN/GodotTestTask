class_name PersistentDataProvider
extends RefCounted

var get_data: Callable
var set_data: Callable
var id: String
var is_global: bool

func _init(i_get_data: Callable, i_set_data: Callable, i_id: String, i_is_global := false):
	get_data = i_get_data
	set_data = i_set_data
	id = i_id
	is_global = i_is_global
	PersistentDataController.add_provider(self)
		
