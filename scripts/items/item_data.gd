class_name ItemData
extends Resource

var item_scene: PackedScene
@export var item_name: String
@export var item_description: String
var item_icon: Texture
var on_pick_up: Callable
var on_use: Callable
var on_drop: Callable
