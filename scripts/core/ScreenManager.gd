extends Node
## Manages screen transitions and navigation

#class_name ScreenManager

var _current_screen: Node = null
var _screen_map: Dictionary = {}  # screen_name -> scene path
var _is_transitioning: bool = false
var _screen_container: Node = null

func _ready() -> void:
	# Screen paths mapping
	_screen_map = {
		"splash": "res://scenes/SplashScreen.tscn",
		"main_menu": "res://scenes/MainMenu.tscn",
		"home": "res://scenes/HomeScreen.tscn",
		"gacha": "res://scenes/GachaScreen.tscn",
		"battle": "res://scenes/BattleScreen.tscn"
	}
	
	_screen_container = Node.new()
	_screen_container.name = "ScreenContainer"
	add_child(_screen_container)

## Load and transition to a screen
func goto_screen(screen_name: String) -> void:
	if _is_transitioning:
		printerr("Screen transition already in progress")
		return
	
	if screen_name not in _screen_map:
		push_error("Unknown screen: %s" % screen_name)
		return
	
	_is_transitioning = true
	EventBus.screen_requested.emit(screen_name)
	
	# Fade out current screen
	if _current_screen:
		await _fade_out(_current_screen)
		_current_screen.queue_free()
	
	# Load new screen
	var scene_path = _screen_map[screen_name]
	var new_screen = load(scene_path).instantiate()
	_screen_container.add_child(new_screen)
	_current_screen = new_screen
	
	# Fade in new screen
	await _fade_in(new_screen)
	EventBus.screen_loaded.emit(screen_name)
	_is_transitioning = false

## Get current screen
func get_current_screen() -> Node:
	return _current_screen

## Internal: fade out animation
func _fade_out(node: Node) -> void:
	if node.has_node("CanvasLayer/FadeRect"):
		var fade_rect = node.get_node("CanvasLayer/FadeRect") as CanvasLayer
		var tween = create_tween()
		tween.tween_property(fade_rect, "modulate", Color.BLACK, Constants.SCREEN_FADE_DURATION)
		await tween.finished
	else:
		await get_tree().create_timer(Constants.SCREEN_FADE_DURATION).timeout

## Internal: fade in animation
func _fade_in(node: Node) -> void:
	if node.has_node("CanvasLayer/FadeRect"):
		var fade_rect = node.get_node("CanvasLayer/FadeRect") as CanvasLayer
		fade_rect.modulate = Color.BLACK
		var tween = create_tween()
		tween.tween_property(fade_rect, "modulate", Color.WHITE, Constants.SCREEN_FADE_DURATION)
		await tween.finished
	else:
		await get_tree().create_timer(Constants.SCREEN_FADE_DURATION).timeout
