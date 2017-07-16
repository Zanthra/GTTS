

gtts_time_scale = 1.0
gtts_fluid_speed = false

if settings.startup["gtts-Target-FrameRate"] then
	gtts_time_scale = 60.0 / settings.startup["gtts-Target-FrameRate"].value
end

if settings.startup["gtts-wag-fluid-speed"] == true then
	gtts_fluid_speed = true
end

exclude_prototype_types = {
	"god-controller",
}

prototype_speeds = {
	"crafting_speed",
	"belt_speed",
	"mining_speed",
	"rotation_speed",
	"turret_rotation_speed",
	"pumping_speed",
	"healing_per_tick",
	"emissions_per_tick",
	"fluid_usage_per_tick",
	"extension_speed",
	"max_speed",
	"braking_force",
	"researching_speed",
	--"speed", --Adjusted in recursive
	"movement_speed",
	"dying_speed",
	"pollution_absorbtion_absolute",
	"pollution_absorbtion_proportional",
	"acceleration",
	"damage_multiplier_decrease_per_tick",
	"folded_speed",
	"attack_speed",
	"ending_attack_speed",
	"folding_speed",
	"preparing_speed",
	"prepared_speed",
	"opening_speed",
	"running_speed",
	"splash_speed",
	"door_opening_speed",
	"light_blinking_speed",
	"engine_starting_speed",
	"flying_speed",
	"flying_acceleration",
	"rising_speed",
	"particle_horizontal_speed",
	"particle_horizontal_speed_deviation",
	"frame_main_scanner_movement_speed",
	"stop_trigger_speed",
	}

prototype_durations = {
	"animation_ticks_per_frame",
	"weight",
	"energy_per_hit_point",
	"life_time",
	"initial_lifetime",
	"lifetime_increase_cooldown",
	"maximum_lifetimie",
	"add_fuel_cooldown",
	"burnt_patch_lifetime",
	"time_before_removed",
	"min_pursue_time",
	"distraction_cooldown",
	"duration",
	"fade_in_duration",
	"fade_out_duration",
	"fade_away_duration",
	"smoke_fade_in_duration",
	"smoke_fade_out_duration",
	"spread_duration",
	"spread_delay",
	"spread_delay_deviation",
	"damage_interval",
	"delay_between_initial_flames",
	"timeout_to_close",
	"charge_cooldown",
	"ticks_to_keep_aiming_direction",
	"ticks_to_keep_gun",
	"ticks_to_stay_in_combat",
	"structure_animation_movement_cooldown",
	"request_to_open_door_timeout",
	"effect_animation_period",
	"effect_animation_period_deviation",
	"time_before_removed",
	"time_to_live",
	"burning_cooldown",
	"action_cooldown",
	"glow_fade_away_duration",
	"duration_in_ticks",
	"flow_length_in_ticks",
}

prototype_power_rates = {
	"energy_consumption",
	"energy_usage",
	"energy_per_tick",
	"energy_usage_per_tick",
	"energy_production",
	"max_power",
	"braking_power",
	"power",
	"max_transfer",
	"consumption",
}


prototype_speeds_recursive = {
	"speed",
	"starting_vertical_speed",
	"starting_vertical_speed_deviation",
}

prototype_durations_recursive = {
	
}
