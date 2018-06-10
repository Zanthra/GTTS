

gtts_time_scale = 1.0
gtts_time_scale_inverse = 1.0
gtts_fluid_speed = false


if settings.startup["gtts-Target-FrameRate"] and settings.startup["gtts-Target-FrameRate"].value >= 6 and settings.startup["gtts-Target-FrameRate"].value <= 300 then
	gtts_time_scale = 60.0 / settings.startup["gtts-Target-FrameRate"].value
	gtts_time_scale_inverse = 1.0 / gtts_time_scale
end

if settings.startup["gtts-fluid-speed"] then
	gtts_fluid_speed = settings.startup["gtts-fluid-speed"].value
end

-- This is a list of type exclusions that will not be adjusted.
exclude_prototype_types = {
	"god-controller",
	"mining-tool", -- Mining tool speed is tied in with player mining speed, but the animation rate is tied to the player property. Skip mining tool speed and fix up the duration in an exception.
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
	"rotation_speed", -- Turing rate for cars and tanks, as well as turning speed for inserters.
	"extension_speed", -- Speed at which inserters extend or contract their hand to pick up items on the other side of belts, or to reach closer or further belts in mods that support it.
	"researching_speed", -- Lab Research speed.

	-------------------
	-- Player Speeds --
	-------------------
	"healing_per_tick", -- Player out of combat healing rate.
	"distance_per_frame", -- Distance over the ground to travel before moving to the next animation frame.
	"movement_speed", -- Player and other mob movement speeds.
	"dying_speed", -- How quickly the aliens croak after they reach 0 HP. Perhaps you too.
	"running_speed", -- Some mobs use running speed instead of movement speed.


	------------------
	-- Vehicles --
	"turret_rotation_speed", -- Turret rotation speed for cars, tanks, turrets and artillery.
	"max_speed", -- A variable affecting the speed at which trains will stop accelerating, even if other factors would allow them to go faster.
	"braking_force", -- Base braking force for trains.
	"friction", -- Friction for cars and tanks as a percent of speed each tick.
	"air-resistance", -- Percent of train speed lost each tick.

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


	----------------------
	-- Pollution speeds --
	----------------------
	"pollution_absorbtion_absolute", -- How much pollution an entity absorbes each tick no matter how much pollution is in that chunk.
	"pollution_absorbtion_proportional", -- What percent of the pollution in a chuck the entity will absorb each tick.
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

	"initial-vertical-speed",
	"initial-frame-speed",
	"opening_speed",
	"splash_speed",
	"particle_horizontal_speed",
	"frame_main_scanner_movement_speed",
	"stop_trigger_speed",
	}

prototype_durations = {
	-- Weight has a big impact on how vehicles move. At low framerates, vehicles will be considered to be moving at
	-- substantial speeds relative to their normal speeds. The energy needed to accelerate their normal weight to
	-- those speeds would be very large as the energy goes up 4x for each 2x increase in speed. Droping the weight
	-- keeps the ratio inline, and allows the simulation of vehicles to be fairly similar given the change in sampling
	-- rate.
	"weight",
	
	-- Another timing method for animations.
	"animation_ticks_per_frame",
	"effect_animation_period",
	"effect_animation_period_deviation",

	-- Actual Durations
	"maximum_lifetimie",
	"life_time",
	"time_before_removed",
	"initial_lifetime",
	"burnt_patch_lifetime",
	"min_pursue_time",
	"distraction_cooldown",
	"duration",
	"fade_in_duration",
	"fade_out_duration",
	"fade_away_duration",
	"smoke_fade_in_duration",
	"smoke_fade_out_duration",
	"spread_duration",
	"ticks_to_keep_aiming_direction",
	"ticks_to_keep_gun",
	"ticks_to_stay_in_combat",
	"time_before_removed",
	"time_to_live",
	"duration_in_ticks",
	
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
}

-- Mostly these properties are here because they relate to smoke which can be generated
-- at a great many different layers in the prototype tree.
prototype_speeds_recursive = {
	"acceleration", -- First adjust for the speed the acceleration grants.
	"acceleration", -- Then adjust for the rate at which the speed is granted.
	"speed", -- Many prototypes have a speed for movement speed, operating speed, etc.

	-- The following are mostly related to projectiles, particles and smoke.
	"starting_speed",
	"starting_frame_speed",
	"starting_vertical_speed",
	"initial_vertical_speed",
	"speed_from_center",
	"frequency",
}

prototype_durations_recursive = {
	
}
