extends Node
## Global event dispatcher for loose coupling between systems

#class_name EventBus

# ===== RESOURCE CHANGE SIGNALS =====
signal gold_changed(new_amount: int, delta: int)
signal gems_changed(new_amount: int, delta: int)
signal gacha_tickets_changed(new_amount: int, delta: int)

# ===== HERO SIGNALS =====
@warning_ignore("UNUSED_SIGNAL")
signal hero_added(hero)
@warning_ignore("UNUSED_SIGNAL")
signal hero_removed(hero_id: String)
@warning_ignore("UNUSED_SIGNAL")
signal hero_level_changed(hero_id: String, new_level: int)
@warning_ignore("UNUSED_SIGNAL")
signal active_team_changed(team_ids: Array[String])

# ===== BATTLE SIGNALS =====
@warning_ignore("UNUSED_SIGNAL")
signal battle_started(stage: int)
@warning_ignore("UNUSED_SIGNAL")
signal battle_turn_executed
@warning_ignore("UNUSED_SIGNAL")
signal battle_ended(victory: bool, rewards: Dictionary)
@warning_ignore("UNUSED_SIGNAL")
signal hero_damaged(hero_id: String, damage_taken: int, current_hp: int)
@warning_ignore("UNUSED_SIGNAL")
signal hero_defeated(hero_id: String)

# ===== GACHA SIGNALS =====
@warning_ignore("UNUSED_SIGNAL")
signal gacha_pull_completed(heroes: Array, rarities_pulled: Array[int])
@warning_ignore("UNUSED_SIGNAL")
signal pity_progress_updated(rare_count: int, legendary_count: int)

# ===== SCREEN SIGNALS =====
@warning_ignore("UNUSED_SIGNAL")
signal screen_requested(screen_name: String)
@warning_ignore("UNUSED_SIGNAL")
signal screen_loaded(screen_name: String)
@warning_ignore("UNUSED_SIGNAL")
signal screen_unloaded(screen_name: String)

# ===== VILLAGE SIGNALS =====
@warning_ignore("UNUSED_SIGNAL")
signal building_upgraded(building_type: int, new_level: int)

# ===== SAVE SIGNALS =====
@warning_ignore("UNUSED_SIGNAL")
signal game_saved
@warning_ignore("UNUSED_SIGNAL")
signal game_loaded(player_data)

# Helper function to emit resource changes
func emit_gold_change(new_amount: int, old_amount: int) -> void:
	var delta = new_amount - old_amount
	gold_changed.emit(new_amount, delta)

func emit_gems_change(new_amount: int, old_amount: int) -> void:
	var delta = new_amount - old_amount
	gems_changed.emit(new_amount, delta)

func emit_gacha_tickets_change(new_amount: int, old_amount: int) -> void:
	var delta = new_amount - old_amount
	gacha_tickets_changed.emit(new_amount, delta)
