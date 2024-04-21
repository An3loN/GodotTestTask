class_name Interactive
extends StaticBody2D

@export var hud_message: String
@export var message_color: Color = Color.WHITE
@export var interaction_area: Area2D
var requested_controllers = ["HudController"]
var hud_controller: HudController
var player: Player
var player_in_area: bool = false
var player_looks: bool = false

func _ready():
	add_to_group("controller_requesters")
	interaction_area.body_entered.connect(on_body_entered)
	interaction_area.body_exited.connect(on_body_exited)

func _process(_delta):
	if player_in_area:
		var look_condition: bool
		match player.character.watch_direction:
			Character.WatchDirection.RIGHT:
				look_condition = player.global_position.x < global_position.x
			Character.WatchDirection.LEFT:
				look_condition = player.global_position.x > global_position.x
			Character.WatchDirection.UP:
				look_condition = player.global_position.y > global_position.y
			Character.WatchDirection.DOWN:
				look_condition = player.global_position.y < global_position.y
		if look_condition and not player_looks:
			player.add_interactive(self)
		elif not look_condition and player_looks:
			player.remove_interactive(self)
		player_looks = look_condition

func _exit_tree():
	if player:
		player.remove_interactive(self)

func on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		if not player:
			player = body
		player_in_area = true

func on_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		player.remove_interactive(self)
		player_in_area = false

func activate():
	hud_controller.show_message(hud_message, message_color)
	_activate()

func _activate():
	pass
