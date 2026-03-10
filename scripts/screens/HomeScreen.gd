extends Control
## Hero management screen

class_name HomeScreen

@onready var back_button = $CanvasLayer/TitleBar/BackButton
@onready var hero_grid = $CanvasLayer/MainContent/HeroListPanel/HeroGridContainer
@onready var team_slots = $CanvasLayer/MainContent/TeamPanel/TeamVBox/TeamSlots
@onready var apply_button = $CanvasLayer/MainContent/TeamPanel/TeamVBox/ApplyButton

var _hero_buttons: Array[Button] = []
var _selected_team: Array[String] = []

# Get references to autoloads
func _get_constants():
	return load("res://scripts/data/Constants.gd")

func _get_screen_manager():
	return get_node("/root/ScreenManager")

func _get_ui_manager():
	return get_node("/root/UIManager")

func _ready() -> void:
	back_button.pressed.connect(_go_back)
	apply_button.pressed.connect(_apply_team)
	
	_refresh_hero_list()
	_update_team_display()

func _refresh_hero_list() -> void:
	# Clear existing buttons
	for child in hero_grid.get_children():
		child.queue_free()
	_hero_buttons.clear()
	
	# Create hero buttons
	var heroes = GameStateManager.get_all_heroes()
	var constants = _get_constants()
	for hero in heroes:
		var button = Button.new()
		button.text = hero.get_display_name()
		button.custom_minimum_size = Vector2(120, 60)
		
		# Color by rarity
		var rarity_color = constants.RARITY_COLORS[hero.rarity]
		button.add_theme_color_override("font_color", rarity_color)
		
		var hero_id = hero.id
		button.pressed.connect(func(): _on_hero_selected(hero_id))
		
		hero_grid.add_child(button)
		_hero_buttons.append(button)

func _on_hero_selected(hero_id: String) -> void:
	var constants = _get_constants()
	# Add or remove from team
	if hero_id in _selected_team:
		_selected_team.erase(hero_id)
	else:
		if _selected_team.size() < constants.MAX_TEAM_SIZE:
			_selected_team.append(hero_id)
	
	_update_team_display()

func _update_team_display() -> void:
	var slots = team_slots.get_children()
	var _active_team = GameStateManager.current_player_data.active_team
	
	for i in range(slots.size()):
		var slot = slots[i]
		if i < _selected_team.size():
			var hero = GameStateManager.current_player_data.get_hero_by_id(_selected_team[i])
			if hero:
				slot.text = "Slot %d: %s" % [i + 1, hero.get_display_name()]
		else:
			slot.text = "Slot %d: Empty" % (i + 1)

func _apply_team() -> void:
	if _selected_team.is_empty():
		_get_ui_manager().show_notification("Team cannot be empty!")
		return
	
	GameStateManager.set_active_team(_selected_team)
	_get_ui_manager().show_notification("Team updated!")

func _go_back() -> void:
	_get_screen_manager().goto_screen("main_menu")
