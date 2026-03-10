extends Control
## Main menu with interactive village map

class_name MainMenu

@onready var home_button = $ButtonsLayer/HomeButton
@onready var gacha_button = $ButtonsLayer/GachaButton
@onready var battle_button = $ButtonsLayer/BattleButton
@onready var gold_label = $HUD/ResourceDisplay/GoldLabel
@onready var gems_label = $HUD/ResourceDisplay/GemsLabel
@onready var tickets_label = $HUD/ResourceDisplay/TicketsLabel
@onready var fade_rect = $FadeRect/FadeOverlay

func _get_screen_manager():
	return get_node("/root/ScreenManager")

func _ready() -> void:
	# Connect button signals
	home_button.pressed.connect(_on_home_pressed)
	gacha_button.pressed.connect(_on_gacha_pressed)
	battle_button.pressed.connect(_on_battle_pressed)
	
	# Add hover effects
	home_button.mouse_entered.connect(func(): home_button.scale = Vector2(1.05, 1.05))
	home_button.mouse_exited.connect(func(): home_button.scale = Vector2(1.0, 1.0))
	gacha_button.mouse_entered.connect(func(): gacha_button.scale = Vector2(1.05, 1.05))
	gacha_button.mouse_exited.connect(func(): gacha_button.scale = Vector2(1.0, 1.0))
	battle_button.mouse_entered.connect(func(): battle_button.scale = Vector2(1.05, 1.05))
	battle_button.mouse_exited.connect(func(): battle_button.scale = Vector2(1.0, 1.0))
	
	# Update resource display
	_update_resources()
	
	# Listen for resource changes
	EventBus.gold_changed.connect(_on_gold_changed)
	EventBus.gems_changed.connect(_on_gems_changed)
	EventBus.gacha_tickets_changed.connect(_on_gacha_tickets_changed)

func _update_resources() -> void:
	var player_data = GameStateManager.current_player_data
	gold_label.text = "⭐ Gold: %d" % player_data.gold
	gems_label.text = "💎 Gems: %d" % player_data.gems
	tickets_label.text = "🎫 Tickets: %d" % player_data.gacha_tickets

func _on_gold_changed(new_amount: int) -> void:
	gold_label.text = "⭐ Gold: %d" % new_amount

func _on_gems_changed(new_amount: int) -> void:
	gems_label.text = "💎 Gems: %d" % new_amount

func _on_gacha_tickets_changed(new_amount: int) -> void:
	tickets_label.text = "🎫 Tickets: %d" % new_amount

func _on_home_pressed() -> void:
	_get_screen_manager().goto_screen("home")

func _on_gacha_pressed() -> void:
	_get_screen_manager().goto_screen("gacha")

func _on_battle_pressed() -> void:
	_get_screen_manager().goto_screen("battle")
