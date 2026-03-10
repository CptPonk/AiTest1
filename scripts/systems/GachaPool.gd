extends Node
## Weighted random gacha pool for hero pulls

class_name GachaPool

## Get a single rarity draw
static func draw_rarity() -> int:
	var rand = randf()
	var cumulative = 0.0
	
	for rarity in range(4):
		cumulative += Constants.GACHA_RATES[rarity]
		if rand <= cumulative:
			return rarity
	
	return Constants.RARITY_COMMON

## Draw 10 heroes, applying pity
static func draw_10_with_pity(player_data) -> Array:
	var heroes: Array = []
	
	for i in range(10):
		var rarity = draw_rarity()
		
		# Check pity for rare
		if player_data.pulls_since_last_rare >= Constants.PITY_RARE_THRESHOLD:
			rarity = maxf(rarity, Constants.RARITY_RARE)
		
		# Check pity for legendary
		if player_data.pulls_since_last_legendary >= Constants.PITY_LEGENDARY_THRESHOLD:
			rarity = Constants.RARITY_LEGENDARY
		
		# Track pity
		player_data.pulls_since_last_rare += 1
		player_data.pulls_since_last_legendary += 1
		
		if rarity >= Constants.RARITY_RARE:
			player_data.pulls_since_last_rare = 0
		if rarity == Constants.RARITY_LEGENDARY:
			player_data.pulls_since_last_legendary = 0
		
		# Create hero (template ID is mocked)
		var hero_id = "hero_%d_%d" % [Time.get_ticks_msec(), i]
		var hero = Hero.new(hero_id, "template_%d" % rarity, rarity)
		heroes.append(hero)
		player_data.total_pulls_made += 1
	
	return heroes

## Draw single hero with pity
static func draw_single_with_pity(player_data):
	var rarity = draw_rarity()
	
	# Check pity for rare
	if player_data.pulls_since_last_rare >= Constants.PITY_RARE_THRESHOLD:
		rarity = maxf(rarity, Constants.RARITY_RARE)
	
	# Check pity for legendary
	if player_data.pulls_since_last_legendary >= Constants.PITY_LEGENDARY_THRESHOLD:
		rarity = Constants.RARITY_LEGENDARY
	
	# Track pity
	player_data.pulls_since_last_rare += 1
	player_data.pulls_since_last_legendary += 1
	
	if rarity >= Constants.RARITY_RARE:
		player_data.pulls_since_last_rare = 0
	if rarity == Constants.RARITY_LEGENDARY:
		player_data.pulls_since_last_legendary = 0
	
	# Create hero
	var hero_id = "hero_%d" % Time.get_ticks_msec()
	var hero = Hero.new(hero_id, "template_%d" % rarity, rarity)
	player_data.total_pulls_made += 1
	
	return hero
