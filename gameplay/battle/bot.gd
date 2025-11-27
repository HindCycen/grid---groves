extends Area2D

signal movement_started
signal movement_ended

var grid_points: Array[Vector2] = []
var current_position: Vector2
var is_moving: bool = false
var move_delay: float = 1.0 / Global.global_speed  # 跳转间隔时间（秒）

# 新增变量用于存储可行走的网格点和当前位置索引
var walkable_grid_points: Array[Vector2] = []
var current_point_index: int = 0

# 定义方向常量
const DIR_UP := Vector2(0, -1)
const DIR_DOWN := Vector2(0, 1)
const DIR_LEFT := Vector2(-1, 0)
const DIR_RIGHT := Vector2(1, 0)
const DIR_TELEPORT := Vector2(0, 0)  # 原地传送方向

# 用于存储slice传递的移动方向
var next_move_direction: Vector2 = Vector2(0, 0)

func initialize_bot() -> void:
	walkable_grid_points = get_parent().get_walkable_grid_points()
	if walkable_grid_points.size() > 0:
		current_position = walkable_grid_points[0]
		global_position = current_position
		current_point_index = 0

func _ready() -> void:
	monitorable = false

func _on_button_pressed() -> void:
	# 启动Bot遍历
	if not is_moving and walkable_grid_points.size() > 0:
		is_moving = true
		monitorable = true
		movement_started.emit()
		move_randomly()

func move_randomly() -> void:
	if not is_moving:
		return
		
	# 检查是否有来自slice的移动指令
	if next_move_direction != Vector2(0, 0):
		var direction = next_move_direction
		next_move_direction = Vector2(0, 0)  # 重置指令
		
		if direction == DIR_TELEPORT:
			teleport_in_place()
		else:
			move_in_direction(direction)
			
		# 发出信号或者执行其他逻辑
		await get_tree().create_timer(move_delay).timeout
		move_randomly()
	else:
		# 没有接收到特定指令时，默认向下移动
		move_in_direction(DIR_DOWN)
		
		# 发出信号或者执行其他逻辑
		await get_tree().create_timer(move_delay).timeout
		move_randomly()

# 根据方向进行移动的新实现
func move_in_direction(direction: Vector2) -> void:
	# 特殊处理原地传送
	if direction == DIR_TELEPORT:
		teleport_in_place()
		return
	
	var target_position = current_position + (direction * Global.grid_size)
	
	# 检查目标位置是否可行
	if walkable_grid_points.has(target_position):
		current_position = target_position
		global_position = current_position
		current_point_index = walkable_grid_points.find(current_position)
	else:
		# 如果目标不可达，检查是否是向下移动且遇到了障碍
		if direction == DIR_DOWN:
			move_to_next_available_column()

# 移动到下一可用列的第一个可用格子
func move_to_next_available_column() -> void:
	# 计算当前所在的行列
	var current_col = (current_position.x - (2 * Global.px_size + Global.half_grid_size)) / Global.grid_size
	var current_row = (current_position.y - (4 * Global.px_size + Global.half_grid_size)) / Global.grid_size
	
	# 寻找下一列
	var next_col = current_col + 1
	# 检查是否超出边界 (最多7列，索引0-6)
	if next_col > 6:
		next_col = 0  # 回到第一列
	
	# 在下一列中寻找第一个可用的格子（从上到下）
	for row in range(5):  # 5行，索引0-4
		var test_position = Vector2(
			next_col * Global.grid_size + (2 * Global.px_size + Global.half_grid_size),
			row * Global.grid_size + (4 * Global.px_size + Global.half_grid_size)
		)
		
		# 检查该位置是否可行走
		if walkable_grid_points.has(test_position):
			current_position = test_position
			global_position = current_position
			current_point_index = walkable_grid_points.find(current_position)
			return
	
	# 如果下一列没有可用格子，则停留在当前位置

# 原地传送功能：先传送到屏幕外，再传送回来
func teleport_in_place() -> void:
	# 保存原始位置
	var original_position = global_position
	
	# 传送到屏幕外
	global_position = Vector2(2000, 2000)
	
	# 等待一段时间
	await get_tree().create_timer(move_delay / 2.0).timeout
	
	# 传送回原来的位置
	global_position = original_position
	
	# 继续移动循环
	await get_tree().create_timer(move_delay / 2.0).timeout
	move_randomly()

# 允许外部调用指定移动方向的方法
func set_next_move_direction(direction: Vector2) -> void:
	next_move_direction = direction