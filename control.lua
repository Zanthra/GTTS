require "config"

local function updatePlayerSettings()
    if settings.global["gtts-Adjust-HandCraftingSpeed"].value == true then
        for _,player in pairs(game.players) do
            if player.character then
                player.character.character_crafting_speed_modifier = gtts_time_scale - 1
            end
        end
    else
        for _,player in pairs(game.players) do
            if player.character then
                player.character.character_crafting_speed_modifier = 0
            end
        end
    end
end

--This turns an array of keys below the global "game" object into
--a table reference and a key in that table as a tuple.
--
--t,k = get_reference(keys)
--
--the reference becomes t[k]
local function get_reference(keys)
    local length = #keys
    local reftable = game
    for i = 1,length-1 do
        reftable = reftable[keys[i]]
    end
    return reftable,keys[length]
end

--Helper method for updating settings given the setting name, the
--global variable to which the previous value of that variable is
--saved, a list of keys to the variable to be changed, and a boolean
--indicating whether it is a speed or duration.
local function update_GTTS_setting(setting, save, targetvariable, speed)
    local t,k = get_reference(targetvariable)

    if settings.global[setting].value == true then
        if not global[save] then
            global[save] = t[k]
        end
        if speed then
            t[k] = global[save] * gtts_time_scale
        else
            t[k] = global[save] / gtts_time_scale
        end
    else
        if global[save] then
            t[k] = global[save]
            global[save] = nil
        end
    end
end


local function updateMapSettings()
    update_GTTS_setting("gtts-Adjust-Pollution", "initial-pollution-diffusionratio", {"map_settings", "pollution", "diffusion_ratio"}, true)
    update_GTTS_setting("gtts-Adjust-Pollution", "initial-pollution-ageing", {"map_settings", "pollution", "ageing"}, true)
    
    update_GTTS_setting("gtts-Adjust-Evolution", "initial-evolution-timefactor", {"map_settings", "enemy_evolution", "time_factor"}, true)

    update_GTTS_setting("gtts-Adjust-Expansion", "initial-expansion-minexpansioncooldown", {"map_settings", "enemy_expansion", "min_expansion_cooldown"}, false)
    update_GTTS_setting("gtts-Adjust-Expansion", "initial-expansion-maxexpansioncooldown", {"map_settings", "enemy_expansion", "max_expansion_cooldown"}, false)

    if game.surfaces["nauvis"] then
        update_GTTS_setting("gtts-Adjust-DayNight", "initial-day-night", {"surfaces", "nauvis", "ticks_per_day"}, false)
        update_GTTS_setting("gtts-Adjust-WindSpeed", "initial-windspeed", {"surfaces", "nauvis", "wind_speed"}, true)
    end

    update_GTTS_setting("gtts-Adjust-Groups", "initial-groups-mingroupgatheringtime", {"map_settings", "unit_group", "min_group_gathering_time"}, false)
    update_GTTS_setting("gtts-Adjust-Groups", "initial-groups-maxgroupgatheringtime", {"map_settings", "unit_group", "max_group_gathering_time"}, false)
    update_GTTS_setting("gtts-Adjust-Groups", "initial-groups-maxwaittimeforlatemembers", {"map_settings", "unit_group", "max_wait_time_for_late_members"}, false)
    update_GTTS_setting("gtts-Adjust-Groups", "initial-groups-ticktolerancewhenmemberarrives", {"map_settings", "unit_group", "tick_tolerance_when_member_arrives"}, false)
end

--Only add events if the safe mode setting is not enabled.
if settings.startup["gtts-z-No-Runtime-Adjustments"].value == false then
    script.on_configuration_changed(
        function (event)
            global["previous-scale"] = 1.0 / game.speed
        end
    )

    script.on_event(defines.events.on_tick,
        function(event)
            --Only change the game speed if the target frame rate has changed or Reset-GameSpeed was disabled.
            --For this we save "previous-speed" in the global table with the last adjusted game speed. This
            --prevents the game speed from being changed if the user, or another mod, changes the game speed.
            if ((not global["previous-speed"]) or (not (global["previous-speed"] == gtts_time_scale_inverse))) and game.tick > 1 then
                if (not global["previous-scale"]) or (not (global["previous-scale"] == gtts_time_scale)) then
                    updateMapSettings()
                    updatePlayerSettings()
                    global["previous-scale"] = gtts_time_scale
                end

                if settings.global["gtts-Reset-GameSpeed"].value == false then
                    if settings.startup["gtts-Adjust-GameSpeed"].value == true then
                        game.speed = gtts_time_scale_inverse
                        global["previous-speed"] = gtts_time_scale_inverse
                    end
                end
            end
        end
    )

    script.on_event(defines.events.on_runtime_mod_setting_changed,
        function(event)
            if settings.global["gtts-Reset-GameSpeed"].value == true then
                game.speed = 1.0
                global["previous-speed"] = 1.0
            end
            updateMapSettings()
            updatePlayerSettings()
        end
    )

    script.on_event(defines.events.on_player_created, updatePlayerSettings)
    script.on_event(defines.events.on_player_joined_game, updatePlayerSettings)
    script.on_event(defines.events.on_player_respawned, updatePlayerSettings)
end