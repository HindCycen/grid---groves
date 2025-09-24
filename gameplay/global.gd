extends Node

@export var grid_size := 16
var half_grid_size := 8
@export var px_size := 20
var grid_points: Array[Vector2] = []
var grid_left_up:= Vector2(2, 4) * px_size
var grid_right_down:= Vector2(7.6, 8) * px_size

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
    for i in range(7):
        for j in range(5):
            grid_points.append(Vector2(i * grid_size, j * grid_size) + Vector2(2 * px_size + half_grid_size, 4 * px_size + half_grid_size))