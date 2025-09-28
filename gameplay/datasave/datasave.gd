extends Node

# 注意：除非SL功能本身出现问题或者有新的字段需要被加载，否则不要轻易修改这个脚本。
# 请在需要修改现有数据时用set_data()和get_data()两个接口。

# 数据存储字典
var game_data: Dictionary = {}

func _ready() -> void:
    init_default_data()
    
# 初始化默认数据结构
func init_default_data() -> void:
    game_data = {
        "player": {
            "health": 100,
            "max_health": 100,
            "coins": 100,
            "level": 0
        },
        "game_state": {
            "current_seed": 0,
            "seed_progress": [0, 0, 0, 0, 0],
            "unlocked_rows": [false, true, true, true, false],
            "unlocked_cols": [false, true, true, true, true, true, false],
        },
        "progress": {
            "completed_levels": [],
            "unlocked_abilities": [],
            "achievements": []
        }
    }

# 保存数据到文件
func save(filename: String = "user://savegame.save") -> void:
    var file = FileAccess.open(filename, FileAccess.WRITE)
    if file:
        var json_string = JSON.stringify(game_data)
        file.store_line(json_string)
        file.close()
        print("Game saved successfully to: ", filename)
    else:
        push_error("Failed to save game data to: ", filename)

# 从文件加载数据
func load(filename: String = "user://savegame.save") -> bool:
    if not FileAccess.file_exists(filename):
        print("No save file found at: ", filename)
        return false
    
    var file = FileAccess.open(filename, FileAccess.READ)
    if file:
        var json_string = file.get_line()
        var json = JSON.new()
        var parse_result = json.parse(json_string)
        
        if parse_result == OK:
            game_data = json.data
            file.close()
            print("Game loaded successfully from: ", filename)
            return true
        else:
            push_error("Failed to parse save file: ", filename)
            file.close()
            return false
    else:
        push_error("Failed to open save file: ", filename)
        return false

# 获取数据值
func get_data(path: String, default = null):
    var keys = path.split(".")
    var current = game_data
    
    for key in keys:
        if typeof(current) == TYPE_DICTIONARY and current.has(key):
            current = current[key]
        else:
            return default
    return current

# 设置数据值
func set_data(path: String, value) -> void:
    var keys = path.split(".")
    var current = game_data
    
    for i in range(keys.size()):
        var key = keys[i]
        
        if i == keys.size() - 1:
            # 最后一个键，设置值
            current[key] = value
        else:
            # 中间键，确保字典存在
            if not current.has(key):
                current[key] = {}
            elif typeof(current[key]) != TYPE_DICTIONARY:
                current[key] = {}
            current = current[key]

# 添加新的数据分类（用于扩展）
func add_category(category_name: String, data: Dictionary = {}) -> void:
    if not game_data.has(category_name):
        game_data[category_name] = data

# 删除数据分类
func remove_category(category_name: String) -> bool:
    if game_data.has(category_name):
        game_data.erase(category_name)
        return true
    return false