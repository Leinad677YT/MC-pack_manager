## CHECK IF PACK EXISTS
    $execute store result score #pack_manager.dep_check pack_manager.data if predicate z_pack_manager:depends/$(checking)/$(pack_id)
##

    execute if score #pack_manager.dep_check pack_manager.data matches 0 run return fail

## REITERATE
    data remove storage pack_manager:user pack_info[-1].requires[-1]
    execute if data storage pack_manager:user pack_info[-1].requires[0] run function pack_manager:control/check_dependencies with storage pack_manager:user pack_info[-1].requires[-1]
##