class_name Character
extends Node2D

enum WatchDirection {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

@export var animated_sprite: AnimatedSprite2D

var direction_animation_dict = {
	WatchDirection.UP: "idle_up",
	WatchDirection.RIGHT: "idle_right",
	WatchDirection.DOWN: "idle_down",
	WatchDirection.LEFT: "idle_left",
}
var _watch_direction := WatchDirection.DOWN
var watch_direction : WatchDirection:
	get:
		return _watch_direction
	set(value):
		set_watch_direction(value)

func set_watch_direction(new_direction: WatchDirection) -> void:
	_watch_direction = new_direction
	animated_sprite.play(direction_animation_dict[watch_direction])


