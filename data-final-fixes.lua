require "config"

---Clamps the given prototype property to the range set in config.lua
---@param type_name string the type name of the prototype being modified
---@param property_name string the name of the property being clamped
---@param base_value number the current value of the property
---@param min_value number? the minimum value to clamp to (inclusive)
---@param max_value number? the maximum value to clamp to (inclusive)
---@return number clamped the property value clamped to `min <= x <= max`
local function clamp_property(type_name, property_name, base_value, min_value, max_value)
	local full_path = type_name .. "." .. property_name
	if not min_value then
		min_value = prototype_values_clamp_low[full_path] or prototype_values_clamp_low[property_name] or math.huge * -1
	end
	if not max_value then
		max_value = prototype_values_clamp_high[full_path] or prototype_values_clamp_high[property_name] or math.huge
	end
	local ret = math.min(math.max(base_value, min_value), max_value)
	if ret ~= base_value then
		log(string.format("CLAMPED: %s.%s,  %s -> %s", type_name, property_name, base_value, ret))
	end
	return ret
end

local function adjust_energy(value)
	local start, stop = string.find(value, "[0123456789.]+")
	--Trim the KW MW KJ MJ etc ending off energy values and append it after adjusting the numbers.
	local new_value = tonumber(string.sub(value, start, stop))
	new_value = new_value * gtts_time_scale
	return tostring(new_value)..string.sub(value, stop + 1, string.len(value))
end


local function adjust_animation(animation)
	-- There are a few animations, notably the player movement speed animation that there is more
	-- than one reference to. If we have already adjusted that animation, we should not adjust it
	-- again. So the property "gtts_adjusted" is set true.
	if not animation["gtts_adjusted"] then
		animation["gtts_adjusted"] = true
		animation["animation_speed"] = (animation["animation_speed"] or 1) * gtts_time_scale
	end
end

--Some characterstics can be many layers deep in the prototypes tree,
--and it's best to go through them recursively. I use this sparingly
--as it's better to put a specific change to the value when something
--is not working right then to try to put an exception here.

local function adjust_prototypes_recursive(object, type_name)
	--local skipall = false

	for _,speed in ipairs(prototype_speeds_recursive) do
		-- Similar to the animations, as a double check to avoid potential
		-- multiple references, tag each property that is changed so we
		-- don't change it again.
		if object[speed] and not object[speed.."+gtts"] then
			
			--skipall = true
			object[speed.."+gtts"] = true

			-- A few speeds are a tables of values. In that case just adjust
			-- all of them.
			if type(object[speed]) == "table" then
				--log("Table speed: "..type_name.." Key: "..speed)
				for index,_ in ipairs(object[speed]) do
					--log(" Value: "..object[speed][index])
					object[speed][index] = object[speed][index] * gtts_time_scale
				end
			else
				if type(object[speed]) == "number" then
					-- log("Object speed: "..type_name.." Key: "..speed.." Value: "..object[speed])
					object[speed] = object[speed] * gtts_time_scale

					-- An exception to the doubling is acceleration as
					-- it is doubly affected by time, so just run the
					-- adjustment again.
					if speed == "acceleration" or speed == "particle_vertical_acceleration" or speed == "acceleration_rate" or speed == "movement_acceleration" then
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

			if type(object[duration]) == "table" then
				--log("Table duration: "..type_name.." Key: "..duration)
				for index,_ in ipairs(object[duration]) do
					--log(" Value: "..object[duration][index])
					object[duration][index] = object[duration][index] / gtts_time_scale
				end
			else
				if type(object[duration]) == "number" then
					object[duration] = clamp_property(type_name, duration, object[duration] / gtts_time_scale)
					--log("duration: "..type_name.." Key: "..duration.." Value: " ..object[duration])
				end
			end
		end
	end

	-- Now recursively work through each sub object of this object, and
	-- adjust animations as nescessary, or just pass it on to this function.
	--
	-- Many animations are grouped into layers and the like, the majority
	-- of the purpose of this recursion is to traverse all layers to reach
	-- all of the pieces of the animations.
	--if not skipall then
		for sub_name, sub_object in pairs(object) do
			-- Don't recursively adjust these objects or anything below them.
			local skip = false
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
						--Handle smoke frequency.
						if sub_name == "smoke" then
							for k,_ in ipairs(sub_object) do
								if sub_object[k]["frequency"] then
									sub_object[k]["frequency"] = sub_object[k]["frequency"] * gtts_time_scale
								end
							end
						end
						-- Handle hatches
						if sub_name == "hatch_definitions" then
							for _,hatch in ipairs(sub_object) do
								hatch["busy_timeout_ticks"] = hatch["busy_timeout_ticks"] or 120
								hatch["hatch_opening_ticks"] = hatch["hatch_opening_ticks"] or 80
							end
						end

						-- Handle asteroid probabilities
						if sub_name == "asteroid_spawn_definitions" then
							for _,def in ipairs(sub_object) do
								if def["probability"] then
									def["probability"] = def["probability"] * gtts_time_scale
								end
							end
						end
						if sub_name == "perceived_performance" then
							if sub_object["performance_to_activity_rate"] then
								sub_object["performance_to_activity_rate"] = sub_object["performance_to_activity_rate"] / gtts_time_scale
							end
						end
						if sub_name == "activity_to_speed_modifiers" then
							if sub_object["multiplier"] then
								sub_object["multiplier"] = sub_object["multiplier"] / gtts_time_scale
							end
						end
						if sub_name == "activity_to_volume_modifiers" then
							if sub_object["multiplier"] then
								sub_object["multiplier"] = sub_object["multiplier"] / gtts_time_scale
							end
						end
						if sub_name == "damage_per_tick" then
							if sub_object["amount"] then
								--local initial = sub_object["amount"]
								sub_object["amount"] = sub_object["amount"] * gtts_time_scale
								
								--log("Object: "..sub_name.." damage adjusted from: "..sub_object["amount"])
							end
						end
						if sub_name == "on_damage_tick_effect" then
							if sub_object["action_delivery"] then
								if sub_object["action_delivery"]["target_effects"] then
									for k,v in ipairs(sub_object["action_delivery"]["target_effects"]) do
										if v["damage"] then
											if v["damage"]["amount"] then
												--local initial = v["damage"]["amount"]
												v["damage"]["amount"] = v["damage"]["amount"] * gtts_time_scale
												--log("Object: "..sub_name.." damage adjusted from: "..v["damage"]["amount"])
											end
										end
									end
								end
							end
						end

						-- Entities with crafting speeds have their own animation
						-- speed control tied to the crafting speed. Since the
						-- crafting speed has already been adjusted, changing the
						-- animation speed will make the animation too fast or too
						-- slow.
						local working_animation = false
						if object["crafting_speed"] or object["animation-speed-coefficient"] then
							if sub_name == "working_visualisations"
								or sub_name == "working_visualisations_disabled"
								or sub_name == "animation"
								or sub_name == "idle_animation"
								or sub_name == "graphics_set" then
								working_animation = true
							end
						end

						if object["type"] == "mining_drill" then
							if sub_name == "animations"
								or sub_name == "shadow_animations"
								or sub_name == "input_fluid_patch_shadow_animations"
								or sub_name == "graphics_set" then
								working_animation = true
							end
						end

						-- If it's not a working animation, pass it back to this
						-- function for further processing.
						if not working_animation then
							adjust_prototypes_recursive(sub_object, type_name)
						end
					end
				end
			end
		end
	--end
end

local function adjust_controller(prototype_type)
	for prototype_name, prototype in pairs(prototype_type) do
		local speed = prototype["movement_speed"]
		speed = speed * gtts_time_scale
		if speed < 0.34375 then
			speed = 0.34375
		end
		prototype["movement_speed"] = speed
	end
end

local function adjust_speeds()
	log("GTTS targeting "..(60/gtts_time_scale).." UPS. Started adjusting speeds by: "..gtts_time_scale.." and durations by: "..(1/gtts_time_scale))

	-- Get all prototype types from data.raw
	for type_name, prototype_type in pairs(data.raw) do
		local skip = false

		--Controller speed value needs a different clamping
		--value, so handle them separately.
		for _, controller in ipairs(controller_names) do
			if type_name == controller then
				adjust_controller(prototype_type)
				skip = true
			end
		end
		
		--Skip any prototype types listed in exclusions
		for _, exclusion in ipairs(exclude_prototype_types) do
			if type_name == exclusion then
				skip = true
			end
		end

		if not skip then
			-- Otherwise grab all the prototypes of that type.
			for prototype_name, prototype in pairs(prototype_type) do
				--Check if this is an animation at prototype level.
				local animation = false

				-- Handle weight for non item prototypes only.
				if not type_name == "item" then
					if prototype["weight"] then
						prototype["weight"] = prototype["weight"] / gtts_time_scale
					end
				end
				if prototype["frame_count"] then
					if prototype["frame_count"] > 1 then
						animation = true
						adjust_animation(prototype)
					end
				end
				if not animation then
					-- Adjust speeds.
					for _,speed in ipairs(prototype_speeds) do
						if prototype[speed] then
							if type(prototype[speed]) == "table" then
								for _,v in ipairs(prototype[speed]) do
									v = v * gtts_time_scale
								end
							else
								prototype[speed] = prototype[speed] * gtts_time_scale
							end
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
							prototype[duration] = clamp_property(type_name, duration, prototype[duration] / gtts_time_scale)
						end
					end
					
					-- Do recursive adjustments.
					adjust_prototypes_recursive(prototype, type_name)
					
					-- Construction robots cannot move if their x and y velocities both individually drop below
					-- 2^-8. Thus the safe minimum speed for robots is 2^-8 * sqrt(2) or about 0.0056
					if type_name == "construction-robot" or type_name == "logistic-robot" then
						if prototype["speed"] and prototype["speed_multiplier_when_out_of_energy"] then
							local depleted_speed = prototype["speed"] * prototype["speed_multiplier_when_out_of_energy"]
							-- a speed of 0 means they will crash when out of energy, and we don't want to override that
							if depleted_speed > 0 then
								prototype["speed_multiplier_when_out_of_energy"] = clamp_property(type_name, "speed_multiplier_when_out_of_energy", prototype["speed_multiplier_when_out_of_energy"], 0.0056 / prototype["speed"])
							end
						end
					end

					-- While splitters have a speed coefficient, it is not actually tied
					-- to their belt speed, so it's not really a coefficient. Adjusting
					-- it as a speed and duration works fine.
					--
					if type_name == "splitter" and prototype["structure_animation_speed_coefficient"] then
						prototype["structure_animation_speed_coefficient"] = prototype["structure_animation_speed_coefficient"] * gtts_time_scale
					end
					if type_name == "splitter" and prototype["structure_animation_movement_cooldown"] then
						prototype["structure_animation_movement_cooldown"] = prototype["structure_animation_movement_cooldown"] / gtts_time_scale
					end

					if type_name == "repair-tool" and prototype["durability"] then
						prototype["durability"] = prototype["durability"] / gtts_time_scale
					end

					--if type_name == "thruster" and prototype["min_performance"] then
					--	if prototype["min_performance"]["fluid_usage"] then
					--		prototype["min_performance"]["fluid_usage"] = prototype["min_performance"]["fluid_usage"] * gtts_time_scale
					--	end
					--end
					--if type_name == "thruster" and prototype["max_performance"] then
					--	if prototype["max_performance"]["fluid_usage"] then
					--		prototype["max_performance"]["fluid_usage"] = prototype["max_performance"]["fluid_usage"] * gtts_time_scale
					--	end
					--end

					--if type_name == "planet" then
					--	if prototype["surface_properties"] then
					--		if prototype["surface_properties"]["gravity"] then
					--			prototype["surface_properties"]["gravity"] = prototype["surface_properties"]["gravity"] * gtts_time_scale
					--		end
					--	end
					--end


					-- Fix the doubled impact of vehicle weight changes of platform acceleration.
					if type_name == "utility-constants" then
						if prototype["space_platform_acceleration_expression"] then
							prototype["space_platform_acceleration_expression"] = prototype["space_platform_acceleration_expression"].." * "..gtts_time_scale
						end
					end


					-- Some adjustments specific to attack_parameters.
					if prototype["attack_parameters"] then
						local attack_params = prototype["attack_parameters"]
						if attack_params["warmup"] then
							attack_params["warmup"] = attack_params["warmup"] / gtts_time_scale
						end
						-- attack_parameters.ammo_type.action.action_delivery
						local delivery = ((attack_params["ammo_type"] or {})["action"] or {})["action_delivery"]
						if delivery then
							if delivery.cooldown then
								delivery.cooldown = delivery.cooldown / gtts_time_scale
							end
							if delivery.duration then
								delivery.duration = clamp_property(type_name, "attack_parameters.ammo_type.action.action_delivery.duration", delivery.duration / gtts_time_scale)
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

					-- Damage per tick is sometimes a type with the ammount as a sub variable.
					if prototype["damage_per_tick"] and prototype["damage_per_tick"]["ammount"] then
						prototype["damage_per_tick"]["ammount"] = prototype["damage_per_tick"]["ammount"] * gtts_time_scale
					end
				end
			end
		end
	end
end


adjust_speeds()