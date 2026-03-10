extends Node
## Orchestrates battle execution and reward application

class_name BattleManager

## Execute a battle and apply rewards
func start_battle(stage: int) -> Dictionary:
	var player_team = GameStateManager.get_active_team()
	
	if player_team.is_empty():
		push_error("No active team set")
		return {}
	
	# Create enemy team based on difficulty
	var enemy_team = _generate_enemy_team(stage, player_team.size())
	
	# Run combat
	var simulator = CombatSimulator.new(player_team, enemy_team)
	var results = simulator.simulate_battle()
	
	# Apply rewards
	if results["victory"]:
		_apply_victory_rewards(stage, results)
		GameStateManager.set_current_stage(stage + 1)
	else:
		_apply_defeat_rewards(results)
	
	GameStateManager.save_game()
	
	return results

## Generate enemy team scaled to difficulty
func _generate_enemy_team(stage: int, team_size: int) -> Array:
	var team: Array = []
	
	for i in range(team_size):
		var enemy = Hero.new("enemy_%d" % i, "enemy_template", Constants.RARITY_COMMON)
		
		# Scale stats by difficulty
		var difficulty_multiplier = 1.0 + (stage - 1) * Constants.DIFFICULTY_STAT_INCREASE_PER_STAGE
		enemy.hp = int(enemy.hp * difficulty_multiplier)
		enemy.atk = int(enemy.atk * difficulty_multiplier)
		enemy.def = int(enemy.def * difficulty_multiplier)
		
		team.append(enemy)
	
	return team

## Apply rewards for victory
func _apply_victory_rewards(_stage: int, results: Dictionary) -> void:
	var player_team = GameStateManager.get_active_team()
	var xp_earned = results.get("xp_earned", 100)
	var gold_earned = results.get("gold_earned", Constants.BATTLE_GOLD_BASE)
	
	# Apply multipliers
	var gold_multiplier = GameStateManager.get_gold_multiplier()
	var xp_multiplier = GameStateManager.get_xp_multiplier()
	
	gold_earned = int(gold_earned * gold_multiplier)
	xp_earned = int(xp_earned * xp_multiplier)
	
	GameStateManager.add_gold(gold_earned)
	GameStateManager.add_gacha_tickets(1)  # 1 ticket per battle
	
	# Grant XP and level up heroes
	for hero in player_team:
		if hero.is_alive():
			hero.add_experience(xp_earned)

## Apply consequences for defeat
func _apply_defeat_rewards(_results: Dictionary) -> void:
	# Possibly reduce resources or apply cooldown
	pass
