

## REITERATE
    data remove storage pack_manager:user pack_info[-1]
    execute if data storage pack_manager:user pack_info[0] run function pack_manager:control/main_loop with storage pack_manager:user pack_info[-1]
##