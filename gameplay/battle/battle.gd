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