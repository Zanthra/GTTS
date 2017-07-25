require "config"

local function adjust_energy(value)
	start, stop = string.find(value, "[0123456789.]+")
	--Trim the KW MW KJ MJ etc ending off energy values and append it after adjusting the numbers.
	new_value = tonumber(string.sub(value, start, stop))
	new_value = new_value * gtts_time_scale
	return tostring(new_value)..string.sub(value, stop + 1, string.len(value))
end


local function adjust_animation(animation)
	if (not animation["distance_per_frame"]) and (not animation["gtts_adjusted"]) then
		animation["gtts_adjusted"] = true
		if animation["animation_speed"] then
			animation["animation_speed"] = animation["animation_speed"] * gtts_time_scale
			if animation["hr_version"] then
				animation["hr_version"]["animation_speed"] = animation["hr_version"]["animation_speed"] * gtts_time_scale
			end
		else
			animation["animation_speed"] = gtts_time_scale
			if animation["hr_version"] then
				animation["hr_version"]["animation_speed"] = gtts_time_scale
			end
		end
	end
end

--Some characterstics can be many layers deep in the prototypes tree,
--and it's best to go through them recursively. I use this sparingly
--as it's better to put a specific change to the value when something
--is not working right then to try to put an exception here.

local function adjust_prototypes_recursive(object)
	for _,speed in ipairs(prototype_speeds_recursive) do
		if object[speed] then
			if type(object[speed]) == "table" then
				for index,_ in ipairs(object[speed]) do
					object[speed][index] = object[speed][index] * gtts_time_scale
				end
			else
				object[speed] = object[speed] * gtts_time_scale
			end
		end
	end

	for _,duration in ipairs(prototype_durations_recursive) do
		if object[speed] then
			object[speed] = object[speed] * gtts_time_scale
		end
	end

	for sub_name,sub_object in pairs(object) do
		if type(sub_object) == "table" then
			if sub_object["frame_count"] then
				if sub_object["frame_count"] > 1 then
					adjust_animation(sub_object)
				end
			else
				if sub_name == "animation" then
					skip_base_animation = false
					if object["crafting_speed"] then
						skip_base_animation = true
					end
					if object["type"] and object["type"] == "mining-drill" then
						skip_base_animation = true
					end
					if object["animation_speed_coefficient"] then
						skip_base_animation = true
					end
					if not skip_base_animation then
						adjust_prototypes_recursive(sub_object)
					end
				else
					if not (object["distance_per_frame"] and (sub_name == "in_motion" or sub_name == "run_animation")) then
						adjust_prototypes_recursive(sub_object)
					end
				end
			end
		end
	end
end



local function adjust_speeds()
	for type_name, prototype_type in pairs(data.raw) do
		skip = false

		--Skip any prototypes listed in exclusions.
		for _, exclusion in ipairs(exclude_prototype_types) do
			if type_name == exclusion then
				skip = true
			end
		end

		if not skip then
			for prototype_name, prototype in pairs(prototype_type) do
			
				for _,speed in ipairs(prototype_speeds) do
					if prototype[speed] then
						prototype[speed] = prototype[speed] * gtts_time_scale
					end
				end

				for _,rate in ipairs(prototype_power_rates) do
					if prototype[rate] then
						prototype[rate] = adjust_energy(prototype[rate])
					end
				end

				for _,duration in ipairs(prototype_durations) do
					if prototype[duration] then
						prototype[duration] = prototype[duration] / gtts_time_scale
					end
				end
				
				adjust_prototypes_recursive(prototype)

				if gtts_fluid_speed then
					if prototype["pressure_to_speed_ratio"] then
						prototype["pressure_to_speed_ratio"] = prototype["pressure_to_speed_ratio"] * gtts_time_scale
					end
				end
				
				if prototype["type"] and (prototype["type"] == "mining-tool" or prototype["type"] == "repair-tool") and prototype["durability"] then
					prototype["durability"] = prototype["durability"] / gtts_time_scale
				end

				if prototype["attack_parameters"] then
					if prototype["attack_parameters"]["cooldown"] then
						prototype["attack_parameters"]["cooldown"] = prototype["attack_parameters"]["cooldown"] / gtts_time_scale
					end
					if prototype["attack_parameters"]["warmup"] then
						prototype["attack_parameters"]["warmup"] = prototype["attack_parameters"]["warmup"] / gtts_time_scale
					end
					if prototype["attack_parameters"]["speed"] then
						prototype["attack_parameters"]["speed"] = prototype["attack_parameters"]["speed"] * gtts_time_scale
					end
					if      prototype["attack_parameters"]["ammo_type"] 
						and prototype["attack_parameters"]["ammo_type"]["action"]
						and prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"] then
						if prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["starting_speed"] then
							prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["starting_speed"] = prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["starting_speed"] * gtts_time_scale
						end
						if prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["cooldown"] then
							prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["cooldown"] = prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["cooldown"] / gtts_time_scale
						end
					end
				end

				if prototype["ammo_type"] then
					if      prototype["ammo_type"]["action"] 
						and prototype["ammo_type"]["action"]["action_delivery"]
						and prototype["ammo_type"]["action"]["action_delivery"]["starting_speed"] then
						prototype["ammo_type"]["action"]["action_delivery"]["starting_speed"] = prototype["ammo_type"]["action"]["action_delivery"]["starting_speed"] * gtts_time_scale
					end
				end

				if prototype["energy_source"] then
					if prototype["energy_source"]["drain"] then
						prototype["energy_source"]["drain"] = adjust_energy(prototype["energy_source"]["drain"])
					end
					if prototype["energy_source"]["input_flow_limit"] then
						prototype["energy_source"]["input_flow_limit"] = adjust_energy(prototype["energy_source"]["input_flow_limit"])
					end
					if prototype["energy_source"]["output_flow_limit"] then
						prototype["energy_source"]["output_flow_limit"] = adjust_energy(prototype["energy_source"]["output_flow_limit"])
					end
					if prototype["energy_source"]["max_transfer"] then
						prototype["energy_source"]["max_transfer"] = adjust_energy(prototype["energy_source"]["max_transfer"])
					end
					if prototype["energy_source"]["emissions"] then
						prototype["energy_source"]["emissions"] = prototype["energy_source"]["emissions"] * gtts_time_scale
					end
					if prototype["energy_source"]["smoke"] then
						if prototype["energy_source"]["smoke"]["frequency"] then
							prototype["energy_source"]["smoke"]["frequency"] = prototype["energy_source"]["smoke"]["frequency"] / gtts_time_scale
						end
						if prototype["energy_source"]["smoke"]["starting_vertical_speed"] then
							prototype["energy_source"]["smoke"]["starting_vertical_speed"] = prototype["energy_source"]["smoke"]["starting_vertical_speed"] * gtts_time_scale
						end
					end
				end

				if prototype["heat_buffer"] then
					if prototype["heat_buffer"]["max_transfer"] then
						prototype["heat_buffer"]["max_transfer"] = adjust_energy(prototype["heat_buffer"]["max_transfer"])
					end
				end

				if prototype["smoke"] then
					if prototype["smoke"]["frequency"] then
						prototype["smoke"]["frequency"] = prototype["smoke"]["frequency"] / gtts_time_scale
					end
					if prototype["smoke"]["starting_vertical_speed"] then
						prototype["smoke"]["starting_vertical_speed"] = prototype["smoke"]["starting_vertical_speed"] * gtts_time_scale
					end
				end

				if prototype["spawning_cooldown"] then
					for i = 1, #prototype["spawning_cooldown"] do
						prototype["spawning_cooldown"][i] = prototype["spawning_cooldown"][i] / gtts_time_scale
					end
				end

				if prototype["damage_per_tick"] and prototype["damage_per_tick"]["ammount"] then
					prototype["damage_per_tick"]["ammount"] = prototype["damage_per_tick"]["ammount"] * gtts_time_scale
				end
				

				
				if prototype["shell_particle"] then
					if prototype["shell_particle"]["speed"] then
						prototype["shell_particle"]["speed"] = prototype["shell_particle"]["speed"] * gtts_time_scale
					end
					if prototype["shell_particle"]["speed_deviation"] then
						prototype["shell_particle"]["speed_deviation"] = prototype["shell_particle"]["speed_deviation"] * gtts_time_scale
					end
					if prototype["shell_particle"]["starting_frame_speed"] then
						prototype["shell_particle"]["starting_frame_speed"] = prototype["shell_particle"]["starting_frame_speed"] * gtts_time_scale
					end
					if prototype["shell_particle"]["starting_frame_speed_deviation"] then
						prototype["shell_particle"]["starting_frame_speed_deviation"] = prototype["shell_particle"]["starting_frame_speed_deviation"] * gtts_time_scale
					end
				end

				if      prototype["created_effect"] 
					and prototype["created_effect"]["action_delivery"]
					and prototype["created_effect"]["action_delivery"]["target_effects"] then
					
					if prototype["created_effect"]["action_delivery"]["target_effects"]["initial_vertical_speed"] then
						prototype["created_effect"]["action_delivery"]["target_effects"]["initial_vertical_speed"] = prototype["created_effect"]["action_delivery"]["target_effects"]["initial_vertical_speed"] * gtts_time_scale
					end
					if prototype["created_effect"]["action_delivery"]["target_effects"]["initial_vertical_speed_deviation"] then
						prototype["created_effect"]["action_delivery"]["target_effects"]["initial_vertical_speed_deviation"] = prototype["created_effect"]["action_delivery"]["target_effects"]["initial_vertical_speed_deviation"] * gtts_time_scale
					end
					if prototype["created_effect"]["action_delivery"]["target_effects"]["speed_from_center"] then
						prototype["created_effect"]["action_delivery"]["target_effects"]["speed_from_center"] = prototype["created_effect"]["action_delivery"]["target_effects"]["speed_from_center"] * gtts_time_scale
					end
					if prototype["created_effect"]["action_delivery"]["target_effects"]["speed_from_center_deviation"] then
						prototype["created_effect"]["action_delivery"]["target_effects"]["speed_from_center_deviation"] = prototype["created_effect"]["action_delivery"]["target_effects"]["speed_from_center_deviation"] * gtts_time_scale
					end
				end

				if prototype["capsule_action"] then
					if prototype["capsule_action"]["cooldown"] then
						prototype["capsule_action"]["cooldown"] = prototype["capsule_action"]["cooldown"] / gtts_time_scale
					end
					if      prototype["capsule_action"]["attack_parameters"] 
						and prototype["capsule_action"]["attack_parameters"]["ammo_type"]
						and prototype["capsule_action"]["attack_parameters"]["ammo_type"]["action"]
						and prototype["capsule_action"]["attack_parameters"]["ammo_type"]["action"]["action_delivery"]
						and prototype["capsule_action"]["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["starting_speed"] then

						prototype["capsule_action"]["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["starting_speed"] = prototype["capsule_action"]["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["starting_speed"] * gtts_time_scale
					end
				end
			end
		end
	end
end


adjust_speeds()
