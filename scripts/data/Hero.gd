extends RefCounted
## Represents a single hero entity with stats, level, and equipment

class_name Hero

var id: String  # Unique ID for each hero instance
var template_id: String  # Reference to base template
var rarity: int
var level: int = 1
var experience: int = 0

# Current stats (modified by level and equipment)
var hp: int
var atk: int
var def: int
var spd: float

# Equipment slots: [helmet, armor, weapon, accessory]
var equipment: Array[String] = ["", "", "", ""]

# Skill ids assigned to this hero
var skill_ids: Array[String] = []

# Internal state
var current_hp: int
var skill_cooldowns: Dictionary = {}

func _init(p_id: String, p_template_id: String, p_rarity: int) -> void:
	id = p_id
	template_id = p_template_id
	rarity = p_rarity
	_initialize_stats()
	current_hp = hp

func _initialize_stats() -> void:
	"""Calculate stats based on level and rarity bonuses"""
	var base_hp = Constants.BASE_HERO_STATS["hp"]
	var base_atk = Constants.BASE_HERO_STATS["atk"]
	var base_def = Constants.BASE_HERO_STATS["def"]
	var base_spd = Constants.BASE_HERO_STATS["spd"]
	
	var rarity_multiplier = Constants.RARITY_STAT_MULTIPLIERS[rarity]
	var level_bonus = level - 1
	
	hp = int(base_hp * rarity_multiplier + Constants.LEVEL_UP_STAT_INCREASE["hp"] * level_bonus)
	atk = int(base_atk * rarity_multiplier + Constants.LEVEL_UP_STAT_INCREASE["atk"] * level_bonus)
	def = int(base_def * rarity_multiplier + Constants.LEVEL_UP_STAT_INCREASE["def"] * level_bonus)
	spd = base_spd

func add_experience(amount: int) -> void:
	"""Add experience; level up if threshold reached"""
	experience += amount
	var xp_per_level = 100 + (level - 1) * 10
	
	while experience >= xp_per_level and level < Constants.MAX_LEVEL:
		experience -= xp_per_level
		level += 1
		_initialize_stats()
		current_hp = hp

func take_damage(damage: int) -> int:
	"""Apply damage reduction from DEF"""
	var reduced_damage = max(1, damage - int(def / 2.0))
	current_hp = max(0, current_hp - reduced_damage)
	return reduced_damage

func heal(amount: int) -> void:
	current_hp = min(hp, current_hp + amount)

func is_alive() -> bool:
	return current_hp > 0

func reset_for_combat() -> void:
	"""Reset combat state before battle"""
	current_hp = hp
	skill_cooldowns.clear()
	for skill_id in skill_ids:
		skill_cooldowns[skill_id] = 0.0

func get_display_name() -> String:
	return "%s (%s) Lv.%d" % [template_id, Constants.RARITY_NAMES[rarity], level]

func to_dict() -> Dictionary:
	"""Serialize for saving"""
	return {
		"id": id,
		"template_id": template_id,
		"rarity": rarity,
		"level": level,
		"experience": experience,
		"equipment": equipment,
		"skill_ids": skill_ids
	}

static func from_dict(data: Dictionary) -> Hero:
	"""Deserialize from saved data"""
	var hero = Hero.new(data["id"], data["template_id"], data["rarity"])
	hero.level = data.get("level", 1)
	hero.experience = data.get("experience", 0)
	#hero.equipment = data.get("equipment", ["", "", "", ""])
	#hero.skill_ids = data.get("skill_ids", [])
	hero._initialize_stats()
	return hero
