extends Node
## Pure combat simulation with no UI coupling

class_name CombatSimulator

var player_team: Array
var enemy_team: Array
var combat_log: Array[String] = []
var current_turn: int = 0

func _init(p_player_team: Array, p_enemy_team: Array) -> void:
	player_team = p_player_team.duplicate()
	enemy_team = p_enemy_team.duplicate()
	
	# Reset combat state for all heroes
	for hero in player_team:
		hero.reset_for_combat()
	for hero in enemy_team:
		hero.reset_for_combat()

## Run full combat simulation until victory/defeat
func simulate_battle() -> Dictionary:
	combat_log.clear()
	current_turn = 0
	
	# Battle loop
	while _has_alive_heroes(player_team) and _has_alive_heroes(enemy_team):
		_execute_turn()
		current_turn += 1
		if current_turn > 1000:  # Safety limit
			push_error("Combat exceeded 1000 turns; breaking")
			break
	
	var player_won = _has_alive_heroes(player_team)
	var results = _generate_battle_results(player_won)
	return results

## Execute one turn of combat
func _execute_turn() -> void:
	var all_heroes = player_team + enemy_team
	
	# Sort by SPD (highest first)
	all_heroes.sort_custom(func(a, b): return a.spd > b.spd)
	
	for hero in all_heroes:
		if not hero.is_alive():
			continue
		
		var is_player_hero = hero in player_team
		var targets = enemy_team if is_player_hero else player_team
		
		# Filter alive targets
		targets = targets.filter(func(t): return t.is_alive())
		if targets.is_empty():
			continue
		
		# Choose target (lowest HP first)
		var target = targets[0]
		for t in targets:
			if t.current_hp < target.current_hp:
				target = t
		
		# Calculate damage
		var damage = hero.atk
		var damage_taken = target.take_damage(damage)
		
		combat_log.append("%s attacks %s for %d damage (HP: %d/%d)" % 
			[hero.get_display_name(), target.get_display_name(), damage_taken, target.current_hp, target.hp])
		
		if not target.is_alive():
			combat_log.append("%s is defeated!" % target.get_display_name())

## Check if team has any alive heroes
func _has_alive_heroes(team: Array[Hero]) -> bool:
	for hero in team:
		if hero.is_alive():
			return true
	return false

## Generate battle results
func _generate_battle_results(player_won: bool) -> Dictionary:
	var xp_earned = 100 if player_won else 50
	var gold_earned = Constants.BATTLE_GOLD_BASE if player_won else 0
	
	var results = {
		"victory": player_won,
		"xp_earned": xp_earned,
		"gold_earned": gold_earned,
		"combat_log": combat_log.duplicate(),
		"player_team_final": player_team.duplicate(),
		"enemy_team_final": enemy_team.duplicate()
	}
	
	return results

## Get combat log
func get_combat_log() -> Array[String]:
	return combat_log.duplicate()
