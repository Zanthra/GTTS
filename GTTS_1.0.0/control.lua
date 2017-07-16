require "config"


script.on_configuration_changed(
    function (e)
        if settings.startup["gtts-Adjust-GameSpeed"] == true then
            game.speed = 1.0 / gtts_time_scale
        end
    end
)