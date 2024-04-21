class_name PlayerInputProvider
extends Node

signal moved(direction: Vector2)
signal interacted()
signal opened_inventory()

var enabled = true
var move_input := Vector2(0.0, 0.0)

func _process(_delta):
	var new_move_input = \
			Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() \
			if enabled else Vector2.ZERO
	if new_move_input != move_input:
		move_input = new_move_input
		moved.emit(new_move_input)
	if Input.is_action_just_pressed("interact"):
		interacted.emit()
	if Input.is_action_just_pressed("open_inventory"):
		opened_inventory.emit()
