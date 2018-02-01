require "config"

script.on_configuration_changed(
    function (event)
        global["previous-scale"] = 1.0 / game.speed
    end
)

function WelcomePlayers()
    for _,player in pairs(game.players) do
        local notification = player.gui.center.add{type = "frame", name = "GTTS Welcome Notification", direction = "vertical", caption = "Welcome to GTTS"}
        local notificationtext =
                        "Welcome to the Global Tick Time Scale mod, if you have not changed the mod settings, \n"..
                        "it will still be set to the factorio default of 60 FPS. Check the mod options in the \n"..
                        "game menu where you can configure a target framerate, and also where you can enable \n"..
                        "map specific options like hand crafting speeds. \n\n"..
                        "I would recommend trying 30 FPS if using the mod to speed up a slow factory, \n"..
                        "or 120 FPS for gaming on high refresh rate display if you get good performance. \n\n"..
                        "The game speed is saved in the save file along with any adjustments in the Map \n"..
                        "tab under Mod settings. You can set the frame rate back to 60 FPS, and disable \n"..
                        "all map adjustments then save the game before disabling the mod to avoid any problems. \n\n"..
                        "Crafting speeds, power rates, and other information based on wall time will display\n"..
                        "innacurately due to how the prototypes are changed. If running at 30 FPS things will\n"..
                        "take twice as long as they display, due to the game assuming that one second is 60 ticks.\n"..
                        "This makes even ratios like 20, 30, or 120 FPS nicer that odd ratios like 42 or 144.\n\n"..
                        "This will not apear again this game, but you can also disable this notification in \n"..
                        "the mod options. \n\n"..
                        "For more information visit the factorio forums at: \n"..
                        "https://forums.factorio.com/viewtopic.php?f=91&t=50281"
        
        local textbox = notification.add{type = "text-box", name = "GTTS Notification", text = notificationtext}
        textbox.read_only = true
        local handler =
        function (event)
            if event.element.name == "GTTS Notification Close" then
                handler = nil
                global["disable-welcome"] = true
                notification.destroy()
            end
        end
        script.on_event(defines.events.on_gui_click, handler)
        local flow = notification.add{type = "flow"}
        flow.add{type = "button", name = "GTTS Notification Close", caption = "Close"}
    end
end




function updatePlayerSettings()
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
    if game.tick > 1 then
    if settings.startup["gtts-Welcome"].value == true and (not global["disable-welcome"]) then
        WelcomePlayers()
    end
end
end

function updateMapSettings()
    if settings.global["gtts-Adjust-Pollution"].value == true then
        if not global["initial-pollution-diffusionratio"] then
            global["initial-pollution-diffusionratio"] = game.map_settings.pollution.diffusion_ratio
        end
        if not global["iniital-pollution-ageing"] then
            global["initial-pollution-ageing"] = game.map_settings.pollution.ageing
        end
        game.map_settings.pollution.diffusion_ratio = global["initial-pollution-diffusionratio"] * gtts_time_scale
        game.map_settings.pollution.ageing = global["initial-pollution-ageing"] * gtts_time_scale
    else
        if global["initial-pollution-diffusionratio"] then
            game.map_settings.pollution.diffusion_ratio = global["initial-pollution-diffusionratio"]
            global["initial-pollution-diffusionratio"] = nil
        end
        if global["initial-pollution-ageing"] then
            game.map_settings.pollution.ageing = global["initial-pollution-ageing"]
            global["initial-pollution-ageing"] = nil
        end
    end

    if settings.global["gtts-Adjust-Evolution"].value == true then
        if not global["initial-evolution-timefactor"] then
            global["initial-evolution-timefactor"] = game.map_settings.enemy_evolution.time_factor
        end
        game.map_settings.enemy_evolution.time_factor = global["initial-evolution-timefactor"] * gtts_time_scale
    else
        if global["initial-evolution-timefactor"] then
            game.map_settings.enemy_evolution.time_factor = global["initial-evolution-timefactor"]
            global["initial-evolution-timefactor"] = nil
        end
    end

    if settings.global["gtts-Adjust-Expansion"].value == true then
        if not global["initial-expansion-minexpansioncooldown"] then
            global["initial-expansion-minexpansioncooldown"] = game.map_settings.enemy_expansion.min_expansion_cooldown
        end
        if not global["iniital-expansion-maxexpansioncooldown"] then
            global["iniital-expansion-maxexpansioncooldown"] = game.map_settings.enemy_expansion.max_expansion_cooldown
        end
        game.map_settings.enemy_expansion.min_expansion_cooldown = global["initial-expansion-minexpansioncooldown"] / gtts_time_scale
        game.map_settings.enemy_expansion.max_expansion_cooldown = global["iniital-expansion-maxexpansioncooldown"] / gtts_time_scale
    else
        if global["initial-expansion-minexpansioncooldown"] then
            game.map_settings.enemy_expansion.min_expansion_cooldown = global["initial-expansion-minexpansioncooldown"]
            global["initial-expansion-minexpansioncooldown"] = nil
        end
        if global["iniital-expansion-maxexpansioncooldown"] then
            game.map_settings.enemy_expansion.max_expansion_cooldown = global["iniital-expansion-maxexpansioncooldown"]
            global["iniital-expansion-maxexpansioncooldown"] = nil
        end
    end

    if settings.global["gtts-Adjust-Groups"].value == true then
        if not global["initial-groups-mingroupgatheringtime"] then
            global["initial-groups-mingroupgatheringtime"] = game.map_settings.unit_group.min_group_gathering_time
        end
        if not global["initial-groups-maxgroupgatheringtime"] then
            global["initial-groups-maxgroupgatheringtime"] = game.map_settings.unit_group.max_group_gathering_time
        end
        if not global["initial-groups-maxwaittimeforlatemembers"] then
            global["initial-groups-maxwaittimeforlatemembers"] = game.map_settings.unit_group.max_wait_time_for_late_members
        end
        if not global["initial-groups-ticktolerancewhenmemberarrives"] then
            global["initial-groups-ticktolerancewhenmemberarrives"] = game.map_settings.unit_group.tick_tolerance_when_member_arrives
        end
        game.map_settings.unit_group.min_group_gathering_time = global["initial-groups-mingroupgatheringtime"] / gtts_time_scale
        game.map_settings.unit_group.max_group_gathering_time = global["initial-groups-maxgroupgatheringtime"] / gtts_time_scale
        game.map_settings.unit_group.max_wait_time_for_late_members = global["initial-groups-maxwaittimeforlatemembers"] / gtts_time_scale
        game.map_settings.unit_group.tick_tolerance_when_member_arrives = global["initial-groups-ticktolerancewhenmemberarrives"] / gtts_time_scale
    else
        if global["initial-groups-mingroupgatheringtime"] then
            game.map_settings.unit_group.min_group_gathering_time = global["initial-groups-mingroupgatheringtime"]
            global["initial-groups-mingroupgatheringtime"] = nil
        end
        if global["initial-groups-maxgroupgatheringtime"] then
            game.map_settings.unit_group.max_group_gathering_time = global["initial-groups-maxgroupgatheringtime"]
            global["initial-groups-maxgroupgatheringtime"] = nil
        end
        if global["initial-groups-maxwaittimeforlatemembers"] then
            game.map_settings.unit_group.max_wait_time_for_late_members = global["initial-groups-maxwaittimeforlatemembers"]
            global["initial-groups-maxwaittimeforlatemembers"] = nil
        end
        if global["initial-groups-ticktolerancewhenmemberarrives"] then
            game.map_settings.unit_group.tick_tolerance_when_member_arrives = global["initial-groups-ticktolerancewhenmemberarrives"]
            global["initial-groups-ticktolerancewhenmemberarrives"] = nil
        end
    end
end

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