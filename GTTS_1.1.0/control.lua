require "config"

script.on_configuration_changed(
    function (event)
        global["previous-scale"] = 1.0 / game.speed
    end
)


script.on_event(defines.events.on_tick,
    function(event)
        if event.tick % 60 == 58 then
            if settings.global["gtts-Reset-GameSpeed"].value == true then
                game.speed = 1.0
                global["previous-scale"] = 1.0
            --Only change the game speed if the target frame rate has changed or Reset-GameSpeed was disabled.
            --For this we save "previous-scale" in the global table with the last adjusted game speed. This
            --prevents the game speed from being changed if the user, or another mod, changes the game speed.
            else
                if (not global["previous-scale"]) or (not (global["previous-scale"] == gtts_time_scale)) then
                    if settings.startup["gtts-Adjust-GameSpeed"].value == true then
                        game.speed = 1.0 / gtts_time_scale
                        global["previous-scale"] = gtts_time_scale
                    end
                end
            end
        end
    end
)