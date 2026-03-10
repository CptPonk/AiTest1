extends RefCounted
## Represents complete player save state

class_name PlayerData

var level: int = 1
var experience: int = 0

# Resources
var gold: int = 1000
var gems: int = 0
var gacha_tickets: int = 10

# Heroes
var heroes: Array = []  # Array of Hero objects
var active_team: Array[String] = []  # Array of hero IDs

# Village
var village_levels: Dictionary = {
	Constants.VILLAGE_BUILDING_BARRACKS: 0,
	Constants.VILLAGE_BUILDING_TREASURY: 0,
	Constants.VILLAGE_BUILDING_SHRINE: 0,
	Constants.VILLAGE_BUILDING_WORKSHOP: 0
}

# Gacha tracking
var total_pulls_made: int = 0
var pulls_since_last_rare: int = 0
var pulls_since_last_legendary: int = 0

# Battle progression
var current_stage: int = 1
var highest_stage_reached: int = 1

# Game state metadata
var creation_timestamp: int = 0
var last_played_timestamp: int = 0
var version: int = Constants.SAVE_FILE_VERSION

func _init() -> void:
	creation_timestamp = Time.get_ticks_msec()
	last_played_timestamp = creation_timestamp
	_create_starter_heroes()

func _create_starter_heroes() -> void:
	"""Create 3 starter heroes on first play"""
	var starter_ids = ["starter_1", "starter_2", "starter_3"]
	for i in range(3):
		var hero = Hero.new(starter_ids[i], "warrior_%d" % i, Constants.RARITY_COMMON)
		hero.level = 5
		heroes.append(hero)
		active_team.append(hero.id)

func add_hero(hero) -> void:
	"""Add a hero to the collection"""
	heroes.append(hero)

func get_hero_by_id(hero_id: String):
	"""Find a hero by ID"""
	for hero in heroes:
		if hero.id == hero_id:
			return hero
	return null

func get_active_team() -> Array:
	"""Get current active team as Hero objects"""
	var team: Array = []
	for hero_id in active_team:
		var hero = get_hero_by_id(hero_id)
		if hero:
			team.append(hero)
	return team

func set_active_team(team_ids: Array[String]) -> void:
	"""Update active team (validation occurs in UI layer)"""
	active_team = team_ids

func to_dict() -> Dictionary:
	"""Serialize for saving"""
	var heroes_data = []
	for hero in heroes:
		heroes_data.append(hero.to_dict())
	
	return {
		"level": level,
		"experience": experience,
		"gold": gold,
		"gems": gems,
		"gacha_tickets": gacha_tickets,
		"heroes": heroes_data,
		"active_team": active_team,
		"village_levels": village_levels,
		"total_pulls_made": total_pulls_made,
		"pulls_since_last_rare": pulls_since_last_rare,
		"pulls_since_last_legendary": pulls_since_last_legendary,
		"current_stage": current_stage,
		"highest_stage_reached": highest_stage_reached,
		"creation_timestamp": creation_timestamp,
		"last_played_timestamp": last_played_timestamp,
		"version": version
	}

static func from_dict(data: Dictionary) -> PlayerData:
	"""Deserialize from saved data"""
	var player_data = PlayerData.new()
	player_data.level = data.get("level", 1)
	player_data.experience = data.get("experience", 0)
	player_data.gold = data.get("gold", 1000)
	player_data.gems = data.get("gems", 0)
	player_data.gacha_tickets = data.get("gacha_tickets", 10)
	
	# Reconstruct heroes
	player_data.heroes.clear()
	for hero_data in data.get("heroes", []):
		player_data.heroes.append(Hero.from_dict(hero_data))
	
	#player_data.active_team = data.get("active_team", [])
	player_data.village_levels = data.get("village_levels", {})
	player_data.total_pulls_made = data.get("total_pulls_made", 0)
	player_data.pulls_since_last_rare = data.get("pulls_since_last_rare", 0)
	player_data.pulls_since_last_legendary = data.get("pulls_since_last_legendary", 0)
	player_data.current_stage = data.get("current_stage", 1)
	player_data.highest_stage_reached = data.get("highest_stage_reached", 1)
	player_data.creation_timestamp = data.get("creation_timestamp", 0)
	player_data.last_played_timestamp = data.get("last_played_timestamp", 0)
	player_data.version = data.get("version", Constants.SAVE_FILE_VERSION)
	
	return player_data
