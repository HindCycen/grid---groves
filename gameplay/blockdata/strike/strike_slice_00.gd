class_name StrikeSlice00 extends Slice

var damage = 6

func on_called() -> void:
    print("StrikeSlice00")
    print(calc_damage())

func calc_damage() -> int:
    return damage