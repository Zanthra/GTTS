GTTC 0.1 2017-06-27
====================

Mod by Zanthra (zanthra@gmail.com)

This mod's goal is to allow the general speed of one game tick, an update to
be adjusted. The inital goal of the mod was to allow the game to run at 120FPS
or higher to have smoother motion on high refresh rate displays. During
testing I discovered it also had some benefit to other mods and their relation
to high speed transport belts like those from Bob's Mods and Factorissimo.

This mod can be used to adjust the speeds of ingame objects to a target 120FPS
as configured in the mod options. This is by default 120, or twice the standard
of 60 UPS Factorio nomally runs at. This target frame rate can be set below
60FPS to potentially speed up slow factories, but this may cause problems with
belt compression and other speed sensitive characteristics. This is almost
assured with high speed belts like those in Bob's Mods.

Time and speed displays ingame will be innacurate based on the UPS ratio.
Wherever the game uses 1 second as the unit of measurement, for crafting times,
energy consumption, vehicle speed, shooting speed, etc, 1 second should be read
as 60 ticks. If your tick rate is 120, and a boiler says it consumes 1.8MW,
that is 1.8MJ per 60 ticks, or 3.6MJ per adjusted second. The mod balances
everything so that all standard rations for factorio still work. Train schedules
on the other hand will always run faster or slower than indicated, as a wait
time of 60 seconds is 3600 ticks, or only 30 seconds at 120 UPS.

Some things are not adjusted by this mod, some due to a reluctance on my part
to adjust anything saved in the game file any more than is nescessary to make
the mod easy to add and remove. Hand crafting speeds is one such rate, as there
is no prototype value, and I would instead have to rely on a game variable. To
manually adjust hand crafting speeds you can use:

/c game.player.character.character_crafting_speed_modifier = -0.5

Where -0.5 indicates 1/2 crafting speed, 0 would indicate default, 1 would
indicate double and so on. You can also check or adjust the following values
from the console.

game.map_settings.pollution.diffusion_ratio
game.map_settings.pollution.ageing
game.map_settings.enemy_evolution.time_factor
game.map_settings.enemy_expansion.min_expansion_cooldown
game.map_settings.enemy_expansion.max_expansion_cooldown
game.map_settings.unit_group.min_group_gathering_time
game.map_settings.unit_group.max_group_gathering_time
game.map_settings.unit_group.max_wait_time_for_late_members

The problem with doing this automatically is that it is difficult to tell if
they have already been adjusted or if they were set that way when the map was
created.

The game speed is stored in the save. This means that if this mod adjusts the
game speed to match the prototype speed adjustments, the game is saved, this
mod is removed or disabled, and the game is loaded again, the game speed may
be out of line with the speed of objects in game. If this happens, simply run
the command "/c game.speed = 1" to restore the default speed.

I do not play multiplayer, so I cannot give any advice.