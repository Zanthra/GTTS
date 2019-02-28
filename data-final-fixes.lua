require "config"

local function adjust_energy(value)
	start, stop = string.find(value, "[0123456789.]+")
	--Trim the KW MW KJ MJ etc ending off energy values and append it after adjusting the numbers.
	new_value = tonumber(string.sub(value, start, stop))
	new_value = new_value * gtts_time_scale
	return tostring(new_value)..string.sub(value, stop + 1, string.len(value))
end


local function adjust_animation(animation)
	-- There are a few animations, notably the player movement speed animation that there is more
	-- than one reference to. If we have already adjusted that animation, we should not adjust it
	-- again. So the property "gtts_adjusted" is set true.
	if not animation["gtts_adjusted"] then
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
		-- Similar to the animations, as a double check to avoid potential
		-- multiple references, tag each property that is changed so we
		-- don't change it again.
		if object[speed] and not object[speed.."-gtts"] then
			object[speed.."-gtts"] = true

			-- A few speeds are a tables of values. In that case just adjust
			-- all of them.
			if type(object[speed]) == "table" then
				for index,_ in ipairs(object[speed]) do
					object[speed][index] = object[speed][index] * gtts_time_scale
				end
			else
				if type(object[speed]) == "number" then
					object[speed] = object[speed] * gtts_time_scale

					-- An exception to the doubling is acceleration as
					-- it is doubly affected by time, so just run the
					-- adjustment again.
					if speed == "acceleration" or speed == "particle_vertical_acceleration" then
						object[speed] = object[speed] * gtts_time_scale
					end
				end
			end
		end
	end

	-- Very similar for durations, if there are any that need ajusted
	-- this fasion.
	for _,duration in ipairs(prototype_durations_recursive) do
		if object[duration] and not object[duration.."+gtts"] then
			object[duration.."+gtts"] = true
			object[duration] = object[duration] / gtts_time_scale
		end
	end

	-- Now recursively work through each sub object of this object, and
	-- adjust animations as nescessary, or just pass it on to this function.
	--
	-- Many animations are grouped into layers and the like, the majority
	-- of the purpose of this recursion is to traverse all layers to reach
	-- all of the pieces of the animations.
	for sub_name,sub_object in pairs(object) do
		-- Don't recursively adjust these objects or anything below them.
		skip = false
		for _, exclusion in ipairs(exclude_recursive) do
			if sub_name == exclusion then
				skip = true
			end
		end
		-- If we don't skip.
		if not skip then
			if type(sub_object) == "table" then
				-- Here is how animations are identified, as an animation
				-- requires more than one frame.
				if sub_object["frame_count"] then
					if sub_object["frame_count"] > 1 then
						adjust_animation(sub_object)
					end
				else
					-- Entities with crafting speeds have their own animation
					-- speed control tied to the crafting speed. Since the
					-- crafting speed has already been adjusted, changing the
					-- animation speed will make the animation too fast or too
					-- slow.
					working_animation = false
					if object["crafting_speed"] or object["animation-speed-coefficient"] then
						if     sub_name == "working_visualisations"
							or sub_name == "working_visualisations_disabled"
							or sub_name == "animation"
							or sub_name == "idle_animation" then
								working_animation = true
						end
					end

					if object["type"] == "mining_drill" then
						if    sub_name == "animations"
						   or sub_name == "shadow_animations" 
						   or sub_name == "input_fluid_patch_shadow_animations" then
							working_animation = true
						end
					end

					-- If it's not a working animation, pass it back to this
					-- function for further processing.
					if not working_animation then
						adjust_prototypes_recursive(sub_object)
					end
				end
			end
		end
	end
end



local function adjust_speeds()
	-- Get all prototype types from data.raw
	for type_name, prototype_type in pairs(data.raw) do
		skip = false

		--Skip any prototype types listed in exclusions.
		for _, exclusion in ipairs(exclude_prototype_types) do
			if type_name == exclusion then
				skip = true
			end
		end

		if not skip then
			-- Otherwise grab all the prototypes of that type.
			for prototype_name, prototype in pairs(prototype_type) do
				-- Adjust speeds.
				for _,speed in ipairs(prototype_speeds) do
					if prototype[speed] then
						prototype[speed] = prototype[speed] * gtts_time_scale
					end
				end
				
				-- Adjust power rates.
				for _,rate in ipairs(prototype_power_rates) do
					if prototype[rate] then
						prototype[rate] = adjust_energy(prototype[rate])
					end
				end
				
				-- Adjust Durations.
				for _,duration in ipairs(prototype_durations) do
					if prototype[duration] then
						prototype[duration] = prototype[duration] / gtts_time_scale
					end
				end
				
				-- Do recursive adjustments.
				adjust_prototypes_recursive(prototype)
				

				-- TOTO: Check changes to fluid movement for more accurate adjustment.
				--
				-- Allow the fluid speed adjustment to be disabled as it may be
				-- terribly inaccurate to simply change the pressure to speed
				-- ratio like this.
				--if gtts_fluid_speed then
				--	if prototype["pressure_to_speed_ratio"] then
				--		prototype["pressure_to_speed_ratio"] = prototype["pressure_to_speed_ratio"] * gtts_time_scale
				--	end
				--end
				

				if type_name == "splitter" and prototype["structure_animation_speed_coefficient"] then
					prototype["structure_animation_speed_coefficient"] = prototype["structure_animation_speed_coefficient"] * gtts_time_scale
				end
				if type_name == "splitter" and prototype["structure_animation_movement_cooldown"] then
					prototype["structure_animation_movement_cooldown"] = prototype["structure_animation_movement_cooldown"] / gtts_time_scale
				end

				if type_name == "repair-tool" and prototype["durability"] then
					prototype["durability"] = prototype["durability"] / gtts_time_scale
				end

				-- Some adjustments specific to attack_parameters.
				if prototype["attack_parameters"] then
					if prototype["attack_parameters"]["cooldown"] then
						prototype["attack_parameters"]["cooldown"] = prototype["attack_parameters"]["cooldown"] / gtts_time_scale
					end
					if prototype["attack_parameters"]["warmup"] then
						prototype["attack_parameters"]["warmup"] = prototype["attack_parameters"]["warmup"] / gtts_time_scale
					end
					if      prototype["attack_parameters"]["ammo_type"] 
						and prototype["attack_parameters"]["ammo_type"]["action"]
						and prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"] then
						if prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["cooldown"] then
							prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["cooldown"] = prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["cooldown"] / gtts_time_scale
						end
						if prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["duration"] then
							prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["duration"] = prototype["attack_parameters"]["ammo_type"]["action"]["action_delivery"]["duration"] / gtts_time_scale
						end
					end
				end

				-- Adjustments for energy sources including idle drain, as well as limits for roboports and accumulators.
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
				end

				-- Adjustments for Nuclear Reactors, Heat Pipes and Heat Exchangers.
				if prototype["heat_buffer"] then
					if prototype["heat_buffer"]["max_transfer"] then
						prototype["heat_buffer"]["max_transfer"] = adjust_energy(prototype["heat_buffer"]["max_transfer"])
					end
				end

				-- Spawning Cooldown is a table with minimum and maximum cooldowns.
				if prototype["spawning_cooldown"] then
					for i = 1, #prototype["spawning_cooldown"] do
						prototype["spawning_cooldown"][i] = prototype["spawning_cooldown"][i] / gtts_time_scale
					end
				end

				-- Damage per tick is a type with the ammount as a sub variable.
				if prototype["damage_per_tick"] and prototype["damage_per_tick"]["ammount"] then
					prototype["damage_per_tick"]["ammount"] = prototype["damage_per_tick"]["ammount"] * gtts_time_scale
				end
				
				-- Poison Capsule.
				if prototype["capsule_action"] then
					if prototype["capsule_action"]["cooldown"] then
						prototype["capsule_action"]["cooldown"] = prototype["capsule_action"]["cooldown"] / gtts_time_scale
					end
				end
			end
		end
	end
end

-- Adjust mining tools seperately to avoid adjusting their "speed" property.
local function adjust_mining_tools()
	for prototype_name, prototype in pairs(data.raw["mining-tool"]) do
		if prototype["durability"] then
			prototype["durability"] = prototype["durability"] / gtts_time_scale
		end
	end
end


adjust_speeds()
adjust_mining_tools()