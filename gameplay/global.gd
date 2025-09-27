extends Node

@export var global_speed:= 1.0

enum GridState {
    FREE,
    UNABLE,
    OCCUPIED
}
@export var grid_size := 16
var half_grid_size := 8
@export var px_size := 20
var grid_points: Array[Vector2] = []
var grid_states: Array[int] = []
var grid_left_up:= Vector2(2, 4) * px_size
var grid_right_down:= Vector2(7.6, 8) * px_size
var unlocked_rows: Array = []
var unlocked_cols: Array = []

@export var current_seed := 0
var map_rand: RandomNumberGenerator
var monster_rand: RandomNumberGenerator
var reward_rand: RandomNumberGenerator
var chest_rand: RandomNumberGenerator
var misc_rand: RandomNumberGenerator

func init_seed(_seed: int) -> void:
	if(_seed == 0):
		current_seed = randi_range(1, 1000000000)
	else:
		current_seed = _seed

func init_rng() -> void:
	map_rand = RandomNumberGenerator.new()
	map_rand.set_seed(current_seed)
	monster_rand = RandomNumberGenerator.new()
	monster_rand.set_seed(current_seed)
	reward_rand = RandomNumberGenerator.new()
	reward_rand.set_seed(current_seed)
	chest_rand = RandomNumberGenerator.new()
	chest_rand.set_seed(current_seed)
	misc_rand = RandomNumberGenerator.new()
	misc_rand.set_seed(current_seed)

func is_point_in_rect(point: Vector2, rect_left_up: Vector2, rect_right_down: Vector2) -> bool:
	return point.x >= rect_left_up.x and point.x <= rect_right_down.x and point.y >= rect_left_up.y and point.y <= rect_right_down.y

func init_grid() -> void:
	init_unlocked_states()
	grid_points.clear()
	grid_states.clear()
	for i in range(7):  # 7列
		for j in range(5):  # 5行
			grid_points.append(Vector2(i * grid_size, j * grid_size) + Vector2(2 * px_size + half_grid_size, 4 * px_size + half_grid_size))
			
			# 检查行列是否可用，设置初始状态
			if is_row_unlocked(j) and is_col_unlocked(i):
				grid_states.append(GridState.FREE)
			else:
				grid_states.append(GridState.UNABLE)

func init_unlocked_states() -> void:
	unlocked_rows.clear()
	unlocked_cols.clear()
	
	# 尝试从数据保存中加载解锁状态
	var saved_rows = DataSave.get_data("game_state.unlocked_rows")
	var saved_cols = DataSave.get_data("game_state.unlocked_cols")
	
	if saved_rows != null and saved_cols != null:
		# 使用保存的数据
		unlocked_rows = saved_rows as Array[bool]
		unlocked_cols = saved_cols as Array[bool]
	else:
		# 如果没有保存的数据，使用默认值
		init_unlocked_states()

# 检查行是否解锁
func is_row_unlocked(row: int) -> bool:
	if row >= 0 and row < unlocked_rows.size():
		return unlocked_rows[row]
	return false

# 检查列是否解锁
func is_col_unlocked(col: int) -> bool:
	if col >= 0 and col < unlocked_cols.size():
		return unlocked_cols[col]
	return false

# 解锁指定行
func unlock_row(row: int) -> void:
	if row >= 0 and row < unlocked_rows.size():
		unlocked_rows[row] = true
		update_grid_states()

# 解锁指定列
func unlock_col(col: int) -> void:
	if col >= 0 and col < unlocked_cols.size():
		unlocked_cols[col] = true
		update_grid_states()

func update_grid_states() -> void:
	for i in range(grid_points.size()):
		var point = grid_points[i]
		# 计算行列索引
		var col = (point.x - (2 * px_size + half_grid_size)) / grid_size
		var row = (point.y - (4 * px_size + half_grid_size)) / grid_size
		
		# 如果行列都解锁，则设置为FREE，否则为UNABLE
		if is_row_unlocked(row) and is_col_unlocked(col):
			if grid_states[i] == GridState.UNABLE:  # 只有原来是UNABLE的才变为FREE
				grid_states[i] = GridState.FREE
		else:
			grid_states[i] = GridState.UNABLE

func get_grid_index(point: Vector2) -> int:
	return grid_points.find(point)

func set_grid_state(index: int, state: int) -> void:
	if index >= 0 and index < grid_states.size():
		grid_states[index] = state

func get_grid_state(index: int) -> int:
	if index >= 0 and index < grid_states.size():
		return grid_states[index]
	return GridState.UNABLE
