extends Node
## Global constants and balance values for Battlefriends

class_name Constants

# ===== RARITY SYSTEM =====
const RARITY_COMMON = 0
const RARITY_RARE = 1
const RARITY_EPIC = 2
const RARITY_LEGENDARY = 3

const RARITY_NAMES = ["Common", "Rare", "Epic", "Legendary"]
const RARITY_COLORS = {
	RARITY_COMMON: Color.WHITE,
	RARITY_RARE: Color.CYAN,
	RARITY_EPIC: Color.MAGENTA,
	RARITY_LEGENDARY: Color.YELLOW
}

# Rarity stat multipliers
const RARITY_STAT_MULTIPLIERS = {
	RARITY_COMMON: 1.0,
	RARITY_RARE: 1.2,
	RARITY_EPIC: 1.4,
	RARITY_LEGENDARY: 1.6
}

# Rarity skill slot counts
const RARITY_SKILL_SLOTS = {
	RARITY_COMMON: 0,
	RARITY_RARE: 1,
	RARITY_EPIC: 2,
	RARITY_LEGENDARY: 3
}

# ===== GACHA RATES =====
const GACHA_RATES = {
	RARITY_COMMON: 0.50,
	RARITY_RARE: 0.35,
	RARITY_EPIC: 0.12,
	RARITY_LEGENDARY: 0.03
}

const PITY_RARE_THRESHOLD = 10  # Guaranteed rare+ at 10 pulls
const PITY_LEGENDARY_THRESHOLD = 50  # Guaranteed legendary at 50 pulls

# ===== HERO BASE STATS =====
const BASE_HERO_STATS = {
	"hp": 100,
	"atk": 20,
	"def": 10,
	"spd": 1.0,  # attacks per second
}

const LEVEL_UP_STAT_INCREASE = {
	"hp": 10,
	"atk": 2,
	"def": 1,
}

# ===== COMBAT =====
const MAX_TEAM_SIZE = 4
const MAX_LEVEL = 100
const COMBAT_TURN_DURATION = 1.0  # seconds per turn
const SKILL_BASE_COOLDOWN = 8.0

# ===== ECONOMY =====
const BATTLE_GOLD_BASE = 50
const BATTLE_GOLD_DIFFICULTY_MULTIPLIER = 10  # +10 gold per stage
const GACHA_TICKET_SINGLE_COST = 1
const GACHA_TICKET_MULTI_COST = 10
const GACHA_TICKETS_PER_BATTLE = 1  # 1 ticket per 3 wins

# Upgrade costs (base; scales with level)
const LEVEL_UP_GOLD_COST_BASE = 100
const LEVEL_UP_GOLD_COST_PER_LEVEL = 50

# ===== VILLAGE UPGRADES =====
const VILLAGE_BUILDING_BARRACKS = 0  # Unlock hero slots
const VILLAGE_BUILDING_TREASURY = 1  # Increase gold gain
const VILLAGE_BUILDING_SHRINE = 2    # Boost XP gain
const VILLAGE_BUILDING_WORKSHOP = 3  # Improve gear quality

const VILLAGE_BUILDING_NAMES = ["Barracks", "Treasury", "Shrine", "Workshop"]

const VILLAGE_UPGRADE_MAX_LEVEL = 10

# Treasury: +5% gold per level
const VILLAGE_GOLD_BONUS_PER_LEVEL = 0.05

# Shrine: +5% XP per level
const VILLAGE_XP_BONUS_PER_LEVEL = 0.05

# Barracks: +1 hero slot per level (up to MAX_TEAM_SIZE)
const VILLAGE_HERO_SLOT_BONUS_PER_LEVEL = 1

# ===== DIFFICULTY SCALING =====
const DIFFICULTY_STAT_INCREASE_PER_STAGE = 0.1  # +10% per stage

# ===== GAME STATE =====
const SAVE_FILE_PATH = "user://battlefriends.json"
const SAVE_FILE_VERSION = 1

# ===== CURRENCY =====
const CURRENCY_GOLD = "gold"
const CURRENCY_GEMS = "gems"
const CURRENCY_GACHA_TICKETS = "gacha_tickets"
const CURRENCY_XP = "xp"

# ===== EQUIPMENT =====
const MAX_EQUIPMENT_SLOTS = 4  # Helmet, Armor, Weapon, Accessory

# ===== UI =====
const SCREEN_FADE_DURATION = 0.3
const CARD_REVEAL_DURATION = 0.6
