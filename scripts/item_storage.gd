class_name ItemStorage
extends RefCounted

signal changed()

var items: Array[ItemData] = []
var _capacity: int
var capacity: int:
	get:
		return _capacity
	set(value):
		_capacity = value
		changed.emit()

var is_full: bool:
	get:
		return len(items) == capacity

func add_item(item_data: ItemData):
	if is_full:
		return
	items.append(item_data)
	changed.emit()

func remove_item(ind: int):
	if ind > capacity -1 or ind < 0:
		return
	items.pop_at(ind)
	changed.emit()
