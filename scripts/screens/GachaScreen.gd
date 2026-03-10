extends Control
## Gacha/pull system screen

class_name GachaScreen

@onready var back_button = $CanvasLayer/TitleBar/BackButton
@onready var single_pull_button = $CanvasLayer/MainContent/PullPanel/PullVBox/PullButtons/SinglePullButton
@onready var ten_pull_button = $CanvasLayer/MainContent/PullPanel/PullVBox/PullButtons/TenPullButton
@onready var results_label = $CanvasLayer/MainContent/PullPanel/PullVBox/ResultsLabel
@onready var pity_label1 = $CanvasLayer/MainContent/PityInfo/PityLabel1
@onready var pity_label2 = $CanvasLayer/MainContent/PityInfo/PityLabel2

# Get references to autoloads
func _get_constants():
	return load("res://scripts/data/Constants.gd")

func _get_screen_manager():
	return get_node("/root/ScreenManager")

func _get_ui_manager():
	return get_node("/root/UIManager")

func _get_gacha_pool():
	return load("res://scripts/systems/GachaPool.gd")

func _ready() -> void:
	back_button.pressed.connect(_go_back)
	single_pull_button.pressed.connect(_single_pull)
	ten_pull_button.pressed.connect(_ten_pull)
	
	_update_pity_display()

func _update_pity_display() -> void:
	var player_data = GameStateManager.current_player_data
	pity_label1.text = "Rare Pity: %d/10" % player_data.pulls_since_last_rare
	pity_label2.text = "Legendary Pity: %d/50" % player_data.pulls_since_last_legendary

func _single_pull() -> void:
	var constants = _get_constants()
	var player_data = GameStateManager.current_player_data
	var gacha_pool = _get_gacha_pool()
	
	if not GameStateManager.remove_gacha_tickets(constants.GACHA_TICKET_SINGLE_COST):
		_get_ui_manager().show_notification("Not enough tickets!")
		return
	
	var hero = gacha_pool.draw_single_with_pity(player_data)
	GameStateManager.add_hero(hero)
	
	results_label.text = "Got: %s (%s)\n" % [hero.template_id, constants.RARITY_NAMES[hero.rarity]]
	_update_pity_display()

func _ten_pull() -> void:
	var constants = _get_constants()
	var player_data = GameStateManager.current_player_data
	var gacha_pool = _get_gacha_pool()
	
	if not GameStateManager.remove_gacha_tickets(constants.GACHA_TICKET_MULTI_COST):
		_get_ui_manager().show_notification("Not enough tickets!")
		return
	
	var heroes = gacha_pool.draw_10_with_pity(player_data)
	var result_text = "10x Pull Results:\n"
	var rarity_counts = {0: 0, 1: 0, 2: 0, 3: 0}
	
	for hero in heroes:
		GameStateManager.add_hero(hero)
		rarity_counts[hero.rarity] += 1
	
	result_text += "Common: %d, Rare: %d, Epic: %d, Legendary: %d\n" % [
		rarity_counts[0], rarity_counts[1], rarity_counts[2], rarity_counts[3]
	]
	
	results_label.text = result_text
	_update_pity_display()

func _go_back() -> void:
	_get_screen_manager().goto_screen("main_menu")
