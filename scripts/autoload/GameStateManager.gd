extends Node
## Central game state manager - singleton autoload

#class_name GameStateManager

var current_player_data: PlayerData

func _ready() -> void:
	# Load SaveSystem - it's an autoload so we can reference it directly
	var save_system = get_node("/root/SaveSystem")
	current_player_data = save_system.load_game()

## Save current state to disk
func save_game() -> void:
	var save_system = get_node("/root/SaveSystem")
	save_system.save_game(current_player_data)

## Add gold to player
func add_gold(amount: int) -> void:
	if amount <= 0:
		return
	current_player_data.gold += amount
	EventBus.gold_changed.emit(current_player_data.gold)
	_queue_save()

## Remove gold from player
func remove_gold(amount: int) -> bool:
	if amount <= 0 or current_player_data.gold < amount:
		return false
	current_player_data.gold -= amount
	EventBus.gold_changed.emit(current_player_data.gold)
	_queue_save()
	return true

## Add gems to player
func add_gems(amount: int) -> void:
	if amount <= 0:
		return
	current_player_data.gems += amount
	EventBus.gems_changed.emit(current_player_data.gems)
	_queue_save()

## Remove gems from player
func remove_gems(amount: int) -> bool:
	if amount <= 0 or current_player_data.gems < amount:
		return false
	current_player_data.gems -= amount
	EventBus.gems_changed.emit(current_player_data.gems)
	_queue_save()
	return true

## Add gacha tickets
func add_gacha_tickets(amount: int) -> void:
	if amount <= 0:
		return
	current_player_data.gacha_tickets += amount
	EventBus.gacha_tickets_changed.emit(current_player_data.gacha_tickets)
	_queue_save()

## Remove gacha tickets
func remove_gacha_tickets(amount: int) -> bool:
	if amount <= 0 or current_player_data.gacha_tickets < amount:
		return false
	current_player_data.gacha_tickets -= amount
	EventBus.gacha_tickets_changed.emit(current_player_data.gacha_tickets)
	_queue_save()
	return true

## Add hero to player's collection
func add_hero(hero: Hero) -> void:
	current_player_data.add_hero(hero)
	_queue_save()

## Get active team
func get_active_team() -> Array:
	return current_player_data.get_active_team()

## Set active team
func set_active_team(team_ids: Array[String]) -> void:
	current_player_data.set_active_team(team_ids)
	_queue_save()

## Get all heroes
func get_all_heroes() -> Array:
	return current_player_data.heroes.duplicate()

## Update current stage
func set_current_stage(stage: int) -> void:
	current_player_data.current_stage = stage
	if stage > current_player_data.highest_stage_reached:
		current_player_data.highest_stage_reached = stage
	_queue_save()

## Upgrade a village building
func upgrade_building(building_type: int) -> bool:
	var current_level = current_player_data.village_levels.get(building_type, 0)
	if current_level >= Constants.VILLAGE_UPGRADE_MAX_LEVEL:
		return false
	
	current_player_data.village_levels[building_type] = current_level + 1
	_queue_save()
	return true

## Get village building level
func get_building_level(building_type: int) -> int:
	return current_player_data.village_levels.get(building_type, 0)

## Get gold multiplier from Treasury
func get_gold_multiplier() -> float:
	var treasury_level = get_building_level(Constants.VILLAGE_BUILDING_TREASURY)
	return 1.0 + (treasury_level * Constants.VILLAGE_GOLD_BONUS_PER_LEVEL)

## Get XP multiplier from Shrine
func get_xp_multiplier() -> float:
	var shrine_level = get_building_level(Constants.VILLAGE_BUILDING_SHRINE)
	return 1.0 + (shrine_level * Constants.VILLAGE_XP_BONUS_PER_LEVEL)

## Queue autosave (debounced)
var _save_pending = false
func _queue_save() -> void:
	if _save_pending:
		return
	_save_pending = true
	await get_tree().process_frame
	save_game()
	_save_pending = false
