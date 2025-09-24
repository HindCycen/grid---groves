extends Node

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