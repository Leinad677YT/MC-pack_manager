## FORCELOAD AUXILIARY DIMENSION
    forceload add 0 0 0 0
    execute unless loaded 0 0 0 run return fail
##

## SCOREBOARD STATUS
    scoreboard objectives add pack_manager.data dummy
    scoreboard players set #pack_manager.load pack_manager.data 0
##

## SET BLOCKS
    setblock 0 0 0 minecraft:repeating_command_block{TrackOutput:1b, auto:1b,Command:"datapack list enabled"}
    setblock 0 1 0 minecraft:repeating_command_block{TrackOutput:1b, auto:1b,Command:"datapack list"}
##

## CREATE STOPWATCH
    stopwatch create zleinad_pack_manager:load
##

return 1