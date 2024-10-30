GTTS 1.7.4 2024-10-27
=====================

The Mod should be updated for Space Age now, although there will be more polishing to do.

This mod changes all available prototype speeds and durations to effectively change the duration of one game tick. This allows players to speed up slow factories by increasing the amount of time the game has to calculate the tick without having to delay the game, or allows the game to be played at higher framerates for players that have high refresh rate monitors.

Due to item locations on belts being quantized to 1/256 of a tile, accurate item movement on belts requires a UPS value of 480/x. Suggested UPS for belt accuracy are:

480, 240, 160, 120, 96, 80, 60, 48, 40, 32, 30, 24, 20, 19.2, 16, 15 and 12

The mod is somewhat limited in what it can change, so references to speeds or rates will be incorrect based on the ratio between the target UPS and the base 60 UPS. If for example a boiler lists it's energy consumption as 7.2 MW it effectively means that it will use 7.2 MJ in 60 ticks. At 30 UPS this will take 2 seconds in wall time, which matches with the normal rate of 3.6 MW at 60 UPS. Because all production and consumption rates are adjusted equally, everything balances out to work at the original Factorio ratios. Unfortunately train schedules are going to be incorrect as well, as they are again based on 1 second being equal to 60 ticks. 

Some of the changes this mod makes are saved in the game file. By default this is limited to only the game speed, so a simple "/c game.speed = 1" command on the console can return the game speed of a modded save to the original 60 UPS. However you can also use the "Reset Game Speed" map specific option to immediately reset the game speed to 60 UPS, as well as disable any other save game stored adjustments like hand crafting speed before saving the game so that the mod can be disabled with minimal disruption.

In safe mode no runtime events are added, meaning the mod can make no changes beyond those made to prototypes when factorio loads. Game Speed must be adjusted manually, along with any hand  crafting speeds.

Useful console Commands:

/c game.speed = {target-ups} / 60
/c game.player.character.character_crafting_speed_modifier = 60 / {target-ups} - 1

Zanthra (zanthra+factoriogtts@gmail.com)

Factorio Mod Portal: https://mods.factorio.com/mods/Zanthra/GTTS
Factorio Forums: https://forums.factorio.com/viewtopic.php?f=144&t=50281
