

gtts_time_scale = 1.0
gtts_time_scale_inverse = 1.0
gtts_fluid_speed = false


if settings.startup["gtts-Target-FrameRate"] and settings.startup["gtts-Target-FrameRate"].value >= 6 and settings.startup["gtts-Target-FrameRate"].value <= 480 then
	gtts_time_scale = 60.0 / settings.startup["gtts-Target-FrameRate"].value
	gtts_time_scale_inverse = 1.0 / gtts_time_scale
end

if settings.startup["gtts-fluid-speed"] then
	gtts_fluid_speed = settings.startup["gtts-fluid-speed"].value
end

controller_names = {
	"god-controller",
	"editor-controller",
	"spectator-controller",
	"remote-controller",
}

-- This is a list of type exclusions that will not be adjusted.
exclude_prototype_types = {
	"mining-tool", -- Mining tool speed is tied in with player mining speed, and the animation rate is tied to the player property.
	"module",
}

exclude_recursive = {

}

prototype_speeds = {
	--------------------
	-- Factory Speeds --
	--------------------
	"crafting_speed", -- Base crafting speed for factory buildings.
	"belt_speed", -- Base belt speeds, also affects the belt animation speed.
	"mining_speed", -- Mining speed is shared with both mining drills and the player.
	"pumping_speed", -- Liquid pump speeds.
	"emissions_per_tick", -- Pollution Production.
	"fluid_usage_per_tick", -- Steam engine and turbine steam usage speed.
	"rotation_speed", -- Turing rate for cars and tanks, as well as turning speed for inserters and radars.
	"researching_speed", -- Lab Research speed.

	-------------------
	-- Player Speeds --
	-------------------
	"distance_per_frame", -- Distance over the ground to travel before moving to the next animation frame.
	"dying_speed", -- How quickly the aliens croak after they reach 0 HP. Perhaps you too.
	"running_speed", -- Some mobs use running speed instead of movement speed.


	--------------
	-- Vehicles --
	--------------
	"turret_rotation_speed", -- Turret rotation speed for cars, tanks, turrets and artillery.
	"braking_force", -- Base braking force for trains.
	"friction", -- Friction for cars and tanks as a percent of speed each tick.
	"friction_force",
	"air-resistance", -- Percent of train speed lost each tick.
	"torso_rotation_speed", -- Spidertron Torso rotation speed
	"max_speed", -- A variable affecting the speed at which trains will stop accelerating, even if other factors would allow them to go faster.
	"torso_bob_speed",

	-------------------
	-- Combat Speeds --
	-------------------
	"folded_speed",
	"folding_speed",
	"prepared_speed",
	"preparing_speed",
	"cannon_parking_speed",
	"attack_speed",
	"ending_attack_speed",
	"damage_multiplier_decrease_per_tick",
	"splash_damage_per_tick",


	----------------------
	-- Pollution speeds --
	----------------------
	"pollution_absorption_absolute", -- How much pollution an entity absorbes each tick no matter how much pollution is in that chunk.
	"pollution_absorption_proportional", -- What percent of the pollution in a chuck the entity will absorb each tick.
	"pollution_absorption_per_second",
	-- Also see emissions-per-tick under buildings above.

	-----------------
	-- Rocket Silo --
	-----------------
	"door_opening_speed", -- How fast the door opens when the rocket is done building.
	"light_blinking_speed", -- How fast the silo lights blink.
	"engine_starting_speed", -- How fast the rocket engine starts.
	"flying_speed", -- How fast the rocket flies, not sure how it differs from the following.
	"flying_acceleration", -- How fast the rocket accelerates.
	"rising_speed", -- Speed the rocket rises from the silo when done building.

	-------------------------
	-- Miscelaneous speeds --
	-------------------------

	"opening_speed",
	"splash_speed",
	"particle_horizontal_speed",
	"frame_main_scanner_movement_speed",
	"stop_trigger_speed",
	"sound_scaling_ratio",
	"sound_minimum_speed",
	"ground_patch_fade_in_speed",

	----------------------
	-- Space Age Speeds --
	----------------------
	
	"arm_speed_base",
	"arm_angular_speed_cap_base",
	"production_health_effect",
	"max_fluid_usage",

	
	}

prototype_durations = {
	-- Weight has a big impact on how vehicles move. At low framerates, vehicles will be considered to be moving at
	-- substantial speeds relative to their normal speeds. The energy needed to accelerate their normal weight to
	-- those speeds would be very large as the energy goes up 4x for each 2x increase in speed. Droping the weight
	-- keeps the ratio inline, and allows the simulation of vehicles to be fairly similar given the change in sampling
	-- rate.
	--
	-- 2.0 added weight property to all items to determine how many can fit on a rocket, so this has to be handled
	-- differntly for differnt prototypoe types.
	--"weight",
	
	-- Another timing method for animations.
	"animation_ticks_per_frame",
	"effect_animation_period",
	"effect_animation_period_deviation",

	-- Actual Durations
	"maximum_lifetimie",
	"life_time",
	"initial_lifetime",
	"burnt_patch_lifetime",
	"min_pursue_time",
	"distraction_cooldown",
	--"duration",
	"fade_in_duration",
	"fade_out_duration",
	"fade_in_out_ticks",
	"fade_away_duration",
	"smoke_fade_in_duration",
	"smoke_fade_out_duration",
	"ticks_to_keep_aiming_direction",
	"ticks_to_keep_gun",
	"ticks_to_stay_in_combat",
	"time_before_removed",
	"time_to_live",
	"opened_duration",
	"robot_opened_duration",
	"particle_alpha_blend_duration",
	"spoil_ticks",
	"time_to_damage",
	"effect_duration",
	"time_to_capture",
	"decay_frame_transition_duration",
	"ground_patch_fade_out_duration",

	-- Cooldowns

	"lifetime_increase_cooldown",
	"add_fuel_cooldown",	
	"charge_cooldown",
	"discharge_cooldown",
	"structure_animation_movement_cooldown",
	"burning_cooldown",
	"action_cooldown",
	"glow_fade_away_duration",
	"turn_after_shooting_cooldown",
	
	--Delays

	"spread_delay",
	"delay_between_initial_flames",
	"overlay_start_delay",

	"turret_return_timeout",
	"timeout_to_close",

	"early_death_ticks",
	"damage_interval",

	"alert_after_time",
	"ground_patch_fade_in_delay",
	"ground_patch_fade_out_start",
	

	"particle_fade_out_duration",
	
	--"particle_spawn_interval",
	--"particle_spawn_timeout",
	
	
	"secondary_picture_fade_out_start",
	"secondary_picture_fade_out_duration",
	
	"duration_in_ticks",

	--------------------------------------
	-- Removed due to incompatabilities --
	--------------------------------------
	--"flow_length_in_ticks", --Causes crashes in some situations at low target frame rates
	--"request_to_open_door_timeout", --Causes robots to get stuck at low target frame rates
}

prototype_power_rates = {
	-- All these have approximately the same meaning.
	"consumption",
	"energy_consumption",
	"idle_energy_usage",
	"energy_usage",
	"energy_per_tick",
	"energy_usage_per_tick",
	"active_energy_usage",
	"lamp_energy_usage",
	"movement_energy_consumption",
	"passive_energy_usage",

	
	-- Production rather than consumption.
	"production",
	"energy_production",

	-- Moving energy around.
	"charging_energy",
	"max_transfer",
	
	-- Limits
	"power",
	"max_power",
	"braking_power",

	-- Misc
	"heating_energy",
	"crane_energy_usage",
}

-- Mostly these properties are here because they relate to smoke which can be generated
-- at a great many different layers in the prototype tree.
--
-- Entries with a * indicate tables of values, such af those for emissions
prototype_speeds_recursive = {
	-- Acceleration is also handled specially in the recursive function since the
	-- function tags the values to prevent them from being changed twice, this
	-- entry is doubled as a reminder.

	"acceleration", -- First adjust for the speed the acceleration grants.
	"acceleration", -- Then adjust for the rate at which the speed is granted.
	
	"acceleration_rate",
	"acceleration_rate",

	"movement_acceleration",
	"movement_acceleration",

	"particle_vertical_acceleration",
	
	"healing_per_tick", -- Player out of combat healing rate.
	"damage_per_tick",

	
	"movement_speed", -- Player and other mob movement speeds.

	"speed", -- Many prototypes have a speed for movement speed, operating speed, etc.

	-- The following are mostly related to projectiles, particles and smoke.
	"starting_speed",
	--"starting_frame_speed",
	"starting_vertical_speed",
	"speed_from_center",
	"initial_vertical_speed",
	"initial_frame_speed",
	"initial_movement_speed",
	"movement_acceleration",
	"frame_speed",
	"emissions_per_minute",
	"emissions_per_second",
	"absorptions_per_second",

	"tree_leaf_distortion_speed_far",
	"tree_leaf_distortion_speed_near",
	"tree_shadow_speed",

	"asteroid_spawning_with_random_orientation_max_speed",
	"ejected_item_speed",

	"train_pushed_by_player_max_speed",
	"walking_sound_count_reduction_rate",
	"moving_sound_count_reduction_rate",

	"fluid_usage",
	"gravity_pull",
	"lightnings_per_chunk_per_tick",
	"minimal_change_per_tick",

	"patrolling_speed",
	"investigating_speed",
	"attacking_speed",
	"enraged_speed",
	"wave_speed",

	--"initial_movement_speed",
	"turn_speed",

	--"absorptions_to_join_attack",
	--"pollution",
	"vertical_turn_rate",
	"horizontal_turn_rate",
	"extension_speed", -- Speed at which inserters extend or contract their hand to pick up items on the other side of belts, or to reach closer or further belts in mods that support it. Also Agricultural Towers.
	"turn_rate",

	
	--"frequency",
}

prototype_durations_recursive = {
	
	"fade_in_ticks",
	"fade_out_ticks",
	
	"particle_spawn_interval",
	"particle_spawn_timeout",

	"ease_in_duration",
	"ease_out_duration",
	"duration",
	
	"spawning_cooldown",

	"platform_to_planet_duration_a",
	"platform_to_planet_duration_b",
    "platform_to_planet_hatch_open",

    "impostor_start_tick",
    "rocket_separation_tick",
    "rocket_separation_end_tick",
    "flight_duration",
    "solo_duration",

	"special_action_tick",
	"draw_switch_tick",
	"intermezzo_min_duration",
	"intermezzo_max_duration",

	"timestamp",
	"busy_timeout_ticks",
	"hatch_opening_ticks",
	"end_time",

	"space_platform_dump_cooldown",
	"asteroid_collector_navmesh_refresh_tick_interval",

	"train_temporary_stop_wait_time",
	"train_time_wait_condition_default",
	"train_inactivity_wait_condition_default",

	"ejected_item_lifetime",
	"music_transition_fade_out_ticks",
	"music_transition_pause_ticks",
	"music_transition_fade_in_ticks",
	"environment_sounds_transition_fade_in_ticks",
	
	"cooldown",
	"delay",
	"time_before_shading_off",
	"spread_duration",
	"repeat_delay",

	"slow_seconds",
	"demolisher_cloud_duration",
	"demolisher_expanding_cloud_interval",
	--"fissure_explosion_delay_ticks",
	"fissure_explosion_particles_delay_ticks",
	"fissure_explosion_damage_delay_ticks",
	"fissure_eruption_ticks",
	"enraged_duration",

	--"distance_cooldown",
}

-- this could be a table, but this makes it more readable below, and the locals are immediately discarded anyway
local int8   = {min = -2^7, max = 2^7-1} -- -128 <= x <= 127
local int16  = {min = -2^15, max = 2^15-1} -- -32,768 <= x <= 32,767
local int32  = {min = -2^31, max = 2^31-1} -- -2,147,483,648 <= x <= 2,147,483,647
local int64  = {min = -2^63, max = 2^63-1} -- unused but defined in docs, -9,223,372,036,854,775,808 <= x <= 9,223,372,036,854,775,807
local uint8  = {min = 0, max = 2^8-1} -- 0 <= x <= 255
local uint16 = {min = 0, max = 2^16-1} -- 0 <= x <= 65,535
local uint32 = {min = 0, max = 2^32-1} -- 0 <= x <= 4,294,967,295
local uint64 = {min = 0, max = 2^64} --0 <= x <= 18,446,744,073,709,551,616

-- keys can be just the property name, or parent_type.property name. Latter has precedence.
prototype_values_clamp_high = {
	time_to_live = uint32.max,
	["fire.fade_out_duration"] = uint32.max, -- shared name with different cap, so defined by type
	["explosion.fade_out_duration"] = uint8.max,
	damage_interval = uint32.max,
	time_before_removed = uint32.max,
	duration = uint32.max,
	["artillery-projectile.duration"] = uint8.max,
	["artillery-projectile.ease_out_duration"] = uint8.max,
	["projectile.duration"] = uint8.max,
	["projectile.ease_out_duration"] = uint8.max,
	duration_in_ticks = uint32.max,
	life_time = uint16.max,
	["attack_parameters.ammo_type.action.action_delivery.duration"] = uint8.max
}


prototype_values_clamp_low = {
	duration = 1,
	duration_in_ticks = 1,
}