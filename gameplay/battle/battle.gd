extends Node2D

func _ready() -> void:
    #print("::main ready")
    Global.init_grid()
    _draw()
    for child in get_children():
        if child is Area2D and child.has_method("initialize_bot"):
            #print("::main child: ", child)
            child.initialize_bot()

func _draw() -> void:
    for i in range(8):
        draw_line(Vector2(2 * Global.px_size + i * Global.grid_size, 4 * Global.px_size),
                  Vector2(2 * Global.px_size + i * Global.grid_size, 8 * Global.px_size), Color.WHITE)
    for j in range(6):
        draw_line(Vector2(2 * Global.px_size, 4 * Global.px_size + j * Global.grid_size),
                  Vector2(7.6 * Global.px_size, 4 * Global.px_size + j * Global.grid_size), Color.WHITE)

func get_walkable_grid_points() -> Array[Vector2]:
    var walkable_points: Array[Vector2] = []
    
    # 遍历所有网格点
    for i in range(Global.grid_points.size()):
        # 检查该点是否可用（不是UNABLE状态）
        if Global.grid_states[i] != Global.GridState.UNABLE:
            walkable_points.append(Global.grid_points[i])
    
    # 按照从左到右、从上到下的顺序排序
    walkable_points.sort_custom(func(a, b):
        if a.x == b.x:
            return a.y < b.y
        return a.x < b.x
    )
    
    return walkable_points