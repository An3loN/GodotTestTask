class_name CameraController
extends Node

@export var camera: Camera2D
var target: Node2D

func _process(_delta):
	if target:
		camera.position = target.position
