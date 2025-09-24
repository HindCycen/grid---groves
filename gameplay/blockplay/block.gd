extends Node2D
"""
	Class for show the whole block.
	var slices: for each slice of the block.
"""
var slices: Array[Node] = []
var is_pressed: bool = false
var original_position: Vector2
var grid_points: Array[Vector2]
var is_placed: bool = false

func _ready() -> void:
	grid_points = Global.grid_points
	original_position = global_position
	for child in get_children():
		if child.has_method("on_called"):
			slices.append(child)
			if child.has_signal("is_pressed"):
				child.connect("is_pressed", Callable(self, "on_child_pressed"))
				child.connect("is_released", Callable(self, "on_child_released"))

func on_child_pressed(child: Node) -> void:
	if slices.has(child):
		is_pressed = true

func on_child_released(child: Node) -> void:
	if slices.has(child):
		is_pressed = false
		if check_condition_P(): # ConditionP是用于检测所有slice都在grid内的条件
			global_position = find_nearest_grid_point(global_position)
			is_placed = true
		else:
			global_position = original_position

func _process(_delta: float) -> void:
	if is_pressed and not is_placed:
		global_position = get_global_mouse_position()

func check_condition_P() -> bool:
	for slice in slices:
		if not Global.is_point_in_rect(slice.global_position, Global.grid_left_up, Global.grid_right_down):
			return false
	return true

func find_nearest_grid_point(target_position: Vector2) -> Vector2:
	if grid_points.is_empty():
		return target_position

	var nearest_point: Vector2 = grid_points[0]
	var min_distance: float = target_position.distance_squared_to(nearest_point)

	for point in grid_points:
		var distance: float = target_position.distance_squared_to(point)
		if distance < min_distance:
			min_distance = distance
			nearest_point = point

	return nearest_point
