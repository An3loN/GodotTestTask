extends Item

@export var teleport_distance := 10.0
var step := 0.2
var layer_mask := 2

func _on_use(player: Player):
	
	var dir := Vector2.from_angle(randf_range(0.0, 2*PI))
	var start_position := Vector2.ZERO
	var furtherest_position := dir * teleport_distance
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.collision_shape.global_position,
			player.collision_shape.global_position + furtherest_position, layer_mask)
	var result = space_state.intersect_ray(query)
	if "position" in result:
		furtherest_position = result["position"]
	var shape_cast := ShapeCast2D.new()
	shape_cast.shape = player.collision_shape.shape
	shape_cast.collision_mask = layer_mask
	add_child(shape_cast)
	shape_cast.global_position = player.collision_shape.global_position
	shape_cast.target_position = furtherest_position
	shape_cast.force_update_transform()
	shape_cast.force_shapecast_update()
	if step > teleport_distance:
		player.position += furtherest_position if len(shape_cast.collision_result) == 0 else Vector2.ZERO
		shape_cast.free()
		return
	var step_i := 0
	var step_amount := teleport_distance / step
	while len(shape_cast.collision_result) > 0:
		shape_cast.target_position = furtherest_position.lerp(start_position, float(step_i+1)/float(step_amount))
		shape_cast.force_update_transform()
		shape_cast.force_shapecast_update()
		step_i += 1
		if step_i >= step_amount:
			shape_cast.free()
			return
	player.position += shape_cast.target_position
