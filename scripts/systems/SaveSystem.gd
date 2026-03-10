extends Node
## Handles game state serialization and persistence

#class_name SaveSystem

## Load player data from disk; return default if not found
func load_game():
	var path = Constants.SAVE_FILE_PATH
	
	if not ResourceLoader.exists(path):
		var new_data = PlayerData.new()
		_save_internal(new_data)
		return new_data
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to read save file: %s" % path)
		return PlayerData.new()
	
	var json_str = file.get_as_text()
	var json = JSON.parse_string(json_str)
	
	if json == null or not json is Dictionary:
		push_error("Failed to parse save file JSON")
		return PlayerData.new()
	
	# Validate version
	if json.get("version", 0) != Constants.SAVE_FILE_VERSION:
		printerr("Save file version mismatch; treating as new game")
		return PlayerData.new()
	
	return PlayerData.from_dict(json)

## Save player data to disk
func save_game(player_data) -> bool:
	player_data.last_played_timestamp = Time.get_ticks_msec()
	return _save_internal(player_data)

func _save_internal(player_data) -> bool:
	var path = Constants.SAVE_FILE_PATH
	var data_dict = player_data.to_dict()
	var json_str = JSON.stringify(data_dict)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing: %s" % path)
		return false
	
	file.store_string(json_str)
	return true

## Delete the save file (for testing/fresh start)
func delete_save() -> void:
	if ResourceLoader.exists(Constants.SAVE_FILE_PATH):
		DirAccess.remove_absolute(Constants.SAVE_FILE_PATH)
