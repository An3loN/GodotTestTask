class_name Pickupable
extends Area2D

@export var pick_up_radius := 1
@onready var collision_shape: CollisionShape2D

func _ready():
	if not has_node("CollisionShape"):
		collision_shape = CollisionShape2D.new()
		collision_shape.shape = CircleShape2D.new()
		collision_shape.shape.radius = pick_up_radius
		add_child(collision_shape)
		collision_shape.name = "CollisionShape"
	else:
		collision_shape = $CollisionShape
	body_entered.connect(on_body_entered)
	PersistentObjectController.register_persistent(self)
	pass

func on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		_picked_up(body)
		queue_free()

func _picked_up(_player: Player):
	pass
