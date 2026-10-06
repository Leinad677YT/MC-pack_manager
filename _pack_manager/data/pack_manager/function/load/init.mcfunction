## FORCELOAD AUXILIARY DIMENSION
    forceload add 0 0 0 0
    execute unless loaded 0 0 0 run return fail
##

## SCOREBOARD STATUS
    scoreboard objectives add pack_manager.data dummy
    scoreboard players set #pack_manager.load pack_manager.data 0
##

## SET BLOCKS
    data modify block 0 1 0 powered set value true
    data modify block 0 1 0 auto set value true
    execute unless block 0 1 0 minecraft:repeating_command_block run setblock 0 1 0 minecraft:repeating_command_block{TrackOutput:1b, auto:1b}
##

## CREATE STOPWATCH
    stopwatch create zleinad_pack_manager:load
##

## IF PACK MANAGER IS NOT LAST FORCE IT
    function pack_manager:load/force_self
##

return 1