GTTS 1.2.0 2017-06-27
====================

Mod by Zanthra (zanthra@gmail.com)

This mod's goal is to allow the general speed of one game tick, an update to
be adjusted. The initial goal of the mod was to allow the game to run at 120FPS
or higher to have smoother motion on high refresh rate displays. During
testing I discovered it also had some benefit to other mods and their relation
to high speed transport belts like those from Bob's Mods and Factorissimo.

This mod can be used to adjust the speeds of ingame objects to a target FPS
as configured in the mod options. This is by default 120, or twice the standard
of 60 UPS Factorio normally runs at. This target frame rate can be set below
60FPS to potentially speed up slow factories, but this may cause problems with
belt compression and other speed sensitive characteristics. This is almost
assured with high speed belts like those in Bob's Mods.

Time and speed displays ingame will be inaccurate based on the UPS ratio.
Wherever the game uses 1 second as the unit of measurement, for crafting times,
energy consumption, vehicle speed, shooting speed, etc, 1 second should be read
as 60 ticks. If your tick rate is 120, and a boiler says it consumes 1.8MW,
that is 1.8MJ per 60 ticks, or 3.6MJ per adjusted second. The mod balances
everything so that all standard ratios for Factorio still work. Train schedules
on the other hand will always run faster or slower than indicated, as a wait
time of 60 seconds is 3600 ticks, or only 30 seconds at 120 UPS.

There are options to adjust the map settings such as pollution spread and
ageing, biter evolution and expansions, attack formation times, as well as
hand crafting rates. Disabling these will set the value back to what it was
when the option was enabled. Interoperability with other mods is not
guaranteed.

The game speed is stored in the save. This means that if this mod adjusts the
game speed to match the prototype speed adjustments, the game is saved, this
mod is removed or disabled, and the game is loaded again, the game speed may
be out of line with the speed of objects in game. If this happens, simply run
the command "/c game.speed = 1" to restore the default speed.

There are several reliable mods for adjusting day length, so I have opted not
to incorporate that feature into this mod.

I do not play multiplayer, so I cannot give any advice.