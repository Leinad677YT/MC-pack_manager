## SCOREBOARD STATUS
    scoreboard players add #pack_manager.load pack_manager.data 1
##

## SET BLOCKS
    data modify block 0 1 0 Command set value "datapack list enabled"
##

## RETURN IF NOT LOADED
    execute unless score #pack_manager.load pack_manager.data matches 3.. run return fail
##

## RETRIEVE DATA
    data modify storage pack_manager:data enabled_datapacks set value []
    execute in pack_manager:void run data modify storage pack_manager:data enabled_datapacks append from block 0 1 0 LastOutput.extra[0].with[1].extra[].insertion
##