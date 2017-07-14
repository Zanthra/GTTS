require "config"


script.on_configuration_changed(
    function (e)
        game.speed = 1.0 / gtts_time_scale
    end
)