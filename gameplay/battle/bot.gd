# File: gameplay/battle/bot.gd
extends Area2D

var grid_points: Array[Vector2] = []
var current_point_index: int = 0
var is_moving: bool = false
var move_delay: float = 1 / Global.global_speed  # 跳转间隔时间（秒）

func _ready() -> void:
    # 初始化位置为第一个网格点
    grid_points = get_parent().get_walkable_grid_points()
    if grid_points.size() > 0:
        global_position = grid_points[0]

func _on_button_pressed() -> void:
    # 启动Bot遍历
    if not is_moving and grid_points.size() > 0:
        is_moving = true
        current_point_index = 0
        move_to_next_point()

func move_to_next_point() -> void:
    # 检查是否已经遍历完所有点
    if current_point_index >= grid_points.size():
        is_moving = false
        return
    
    # 瞬时跳转到目标位置
    global_position = grid_points[current_point_index]
    
    await get_tree().create_timer(0.01).timeout
    # 增加索引准备下次移动
    current_point_index += 1
    
    # 设置延迟后继续移动
    if current_point_index < grid_points.size():
        await get_tree().create_timer(move_delay).timeout
        move_to_next_point()
    else:
        is_moving = false