## SAVE DEPENDENCIES
    $execute if data storage pack_manager:user pack_info[-1].requires[0] run data modify storage pack_manager:user pack_info[-1].requires[] merge value {checking: $(pack_id)}
    execute if data storage pack_manager:user pack_info[-1].requires[0] run function pack_manager:control/check_dependencies with storage pack_manager:user pack_info[-1].requires[-1]
##

## IF LOOP FAILED SHOW FAILURE, EXECUTE FAILURE FUNCTION AND DISABLE PACK
    execute if data storage pack_manager:user pack_info[-1].requires[0] run scoreboard players set #pack_manager.dep_error pack_manager.data 1
    $execute if score #pack_manager.dep_error pack_manager.data matches 1 run function z_pack_manager:error/$(pack_id) with storage pack_manager:user pack_info[-1].requires[0]
    $execute if score #pack_manager.dep_error pack_manager.data matches 1 run tellraw @a[tag=pack_manager.admin] [{text:"[!] ",color:"#aa0000"},{translate:"leinad.pack_manager.dependency_error.tellraw", fallback:"%1$s failed to load a dependency, disabling pack",color:"#ff2222",with:[{"text":'"$(pack_id)"',color:"#ffaa33"}]}]
    scoreboard players reset #pack_manager.dep_error
##

## REITERATE
    data remove storage pack_manager:user pack_info[-1]
    execute if data storage pack_manager:user pack_info[0] run function pack_manager:control/main_loop with storage pack_manager:user pack_info[-1]
##