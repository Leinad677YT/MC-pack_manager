## RETRIEVE DATA
    data modify storage pack_manager:data disabled_datapacks set value []
    
    # disabled packs have different format depending on if there's 1 or more
    execute store result score #sync.temp pack_manager.data in pack_manager:void run data get block 0 1 0 LastOutput.extra[0].with[0]
    execute if score #sync.temp pack_manager.data matches 2.. in pack_manager:void run data modify storage pack_manager:data disabled_datapacks append from block 0 1 0 LastOutput.extra[0].with[1].extra[].insertion
    execute unless score #sync.temp pack_manager.data matches 2.. in pack_manager:void run data modify storage pack_manager:data disabled_datapacks append from block 0 1 0 LastOutput.extra[0].with[1].insertion 
##

## CLEAR TEMP DATA
    scoreboard players reset #sync.temp pack_manager.data
##