extends Node
## Centralized UI state management and updates

#class_name UIManager

var _resource_displays: Dictionary = {}  # screen_name -> {gold_label, gems_label, etc}

func _ready() -> void:
	# Connect to resource change signals
	EventBus.gold_changed.connect(_on_gold_changed)
	EventBus.gems_changed.connect(_on_gems_changed)
	EventBus.gacha_tickets_changed.connect(_on_gacha_tickets_changed)
	EventBus.screen_loaded.connect(_on_screen_loaded)

## Register a UI element for updates
func register_resource_display(screen_name: String, gold_label: Label = null, gems_label: Label = null, tickets_label: Label = null) -> void:
	if screen_name not in _resource_displays:
		_resource_displays[screen_name] = {}
	
	if gold_label:
		_resource_displays[screen_name]["gold"] = gold_label
	if gems_label:
		_resource_displays[screen_name]["gems"] = gems_label
	if tickets_label:
		_resource_displays[screen_name]["tickets"] = tickets_label

## Update all resource displays on screen
func update_all_displays(screen_name: String) -> void:
	if screen_name not in _resource_displays:
		return
	
	var displays = _resource_displays[screen_name]
	if "gold" in displays and displays["gold"]:
		displays["gold"].text = "Gold: %d" % GameStateManager.current_player_data.gold
	if "gems" in displays and displays["gems"]:
		displays["gems"].text = "Gems: %d" % GameStateManager.current_player_data.gems
	if "tickets" in displays and displays["tickets"]:
		displays["tickets"].text = "Tickets: %d" % GameStateManager.current_player_data.gacha_tickets

func _on_gold_changed(new_amount: int, _delta: int) -> void:
	for screen_displays in _resource_displays.values():
		if "gold" in screen_displays and screen_displays["gold"]:
			screen_displays["gold"].text = "Gold: %d" % new_amount

func _on_gems_changed(new_amount: int, _delta: int) -> void:
	for screen_displays in _resource_displays.values():
		if "gems" in screen_displays and screen_displays["gems"]:
			screen_displays["gems"].text = "Gems: %d" % new_amount

func _on_gacha_tickets_changed(new_amount: int, _delta: int) -> void:
	for screen_displays in _resource_displays.values():
		if "tickets" in screen_displays and screen_displays["tickets"]:
			screen_displays["tickets"].text = "Tickets: %d" % new_amount

func _on_screen_loaded(screen_name: String) -> void:
	update_all_displays(screen_name)

## Show a temporary notification (center of screen)
func show_notification(message: String, duration: float = 2.0) -> void:
	var label = Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", 24)
	label.anchor_left = 0.5
	label.anchor_top = 0.5
	label.offset_left = -200
	label.offset_top = -50
	label.custom_minimum_size = Vector2(400, 100)
	get_tree().root.add_child(label)
	
	await get_tree().create_timer(duration).timeout
	label.queue_free()
