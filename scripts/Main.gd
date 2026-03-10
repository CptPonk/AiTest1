extends Node
## Main game entry point

func _ready() -> void:
	# Initialize ScreenManager and start with splash screen
	await get_tree().process_frame
	get_node("/root/ScreenManager").goto_screen("splash")
