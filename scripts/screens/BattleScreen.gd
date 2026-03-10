extends Control
## Battle screen showing combat progression

class_name BattleScreen

@onready var back_button = $CanvasLayer/TitleBar/BackButton
@onready var stage_label = $CanvasLayer/TitleBar/StageLabel
@onready var battle_status = $CanvasLayer/MainContent/CombatPanel/CombatVBox/BattleStatus
@onready var combat_log = $CanvasLayer/MainContent/CombatPanel/CombatVBox/CombatLog
@onready var start_button = $CanvasLayer/MainContent/CombatPanel/CombatVBox/BattleControls/StartBattleButton
@onready var player_heroes_container = $CanvasLayer/MainContent/PlayerTeamPanel/PlayerTeamVBox/PlayerHeroes
@onready var enemy_heroes_container = $CanvasLayer/MainContent/EnemyTeamPanel/EnemyTeamVBox/EnemyHeroes

var _current_stage: int = 1
var _battle_in_progress: bool = false

func _get_screen_manager():
	return get_node("/root/ScreenManager")

func _ready() -> void:
	back_button.pressed.connect(_go_back)
	start_button.pressed.connect(_start_battle)
	
	_current_stage = GameStateManager.current_player_data.current_stage
	stage_label.text = "STAGE: %d" % _current_stage
	
	_display_player_team()

func _display_player_team() -> void:
	# Clear existing
	for child in player_heroes_container.get_children():
		child.queue_free()
	
	var team = GameStateManager.get_active_team()
	if team.is_empty():
		battle_status.text = "No team selected! Please go to Home and set a team."
		start_button.disabled = true
		return
	
	for hero in team:
		var label = Label.new()
		label.text = "%s (HP: %d)" % [hero.get_display_name(), hero.hp]
		player_heroes_container.add_child(label)

func _start_battle() -> void:
	if _battle_in_progress:
		return
	
	_battle_in_progress = true
	start_button.disabled = true
	battle_status.text = "Battle in progress..."
	combat_log.clear()
	
	# Run battle
	var battle_manager = BattleManager.new()
	var results = battle_manager.start_battle(_current_stage)
	
	# Display results
	_display_battle_results(results)
	
	_battle_in_progress = false

func _display_battle_results(results: Dictionary) -> void:
	if results.is_empty():
		battle_status.text = "Battle failed!"
		return
	
	var victory = results.get("victory", false)
	var xp_earned = results.get("xp_earned", 0)
	var gold_earned = results.get("gold_earned", 0)
	var combat_log_entries = results.get("combat_log", [])
	
	# Update status
	battle_status.text = "VICTORY!" if victory else "DEFEAT!"
	
	# Display combat log
	combat_log.text = ""
	for entry in combat_log_entries:
		combat_log.append_text(entry + "\n")
	
	combat_log.append_text("\n--- RESULTS ---\n")
	combat_log.append_text("XP Earned: %d\n" % xp_earned)
	combat_log.append_text("Gold Earned: %d\n" % gold_earned)
	
	# Update team display with final state
	var _player_team = results.get("player_team_final", [])
	enemy_heroes_container.call_deferred("_display_enemy_team", results.get("enemy_team_final", []))
	
	# Enable next battle button
	start_button.disabled = false
	if victory:
		_current_stage += 1
		stage_label.text = "STAGE: %d" % _current_stage

func _display_enemy_team(enemy_team: Array[Hero]) -> void:
	for child in enemy_heroes_container.get_children():
		child.queue_free()
	
	for hero in enemy_team:
		var label = Label.new()
		var status = "Alive"
		if hero.current_hp <= 0:
			status = "Defeated"
		label.text = "%s (%d/%d HP) - %s" % [hero.get_display_name(), hero.current_hp, hero.hp, status]
		enemy_heroes_container.add_child(label)

func _go_back() -> void:
	_get_screen_manager().goto_screen("main_menu")
