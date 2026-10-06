## TIMER FOR LOAD
    stopwatch restart zleinad_pack_manager:load
##

## INITIALIZE IF NOT YET
    execute in pack_manager:void unless score #pack_manager.load pack_manager.data matches 0.. unless function pack_manager:load/init run return run schedule function pack_manager:load/main 1t
##

## GET ENABLED PACKS
    execute in pack_manager:void unless score #pack_manager.load pack_manager.data matches 3.. unless function pack_manager:load/get_enabled run return run schedule function pack_manager:load/main 1t
##

## GET DISABLED PACKS
    execute in pack_manager:void unless score #pack_manager.load pack_manager.data matches 6.. unless function pack_manager:load/get_disabled run return run schedule function pack_manager:load/main 1t
##

## DISABLE CMDBLOCK
    execute in pack_manager:void run data modify block 0 1 0 powered set value false
    execute in pack_manager:void run data modify block 0 1 0 auto set value false
##

## SATISFY DEPENDENCIES
    function #z_pack_manager:get_pack_info
    execute if data storage pack_manager:user pack_info[0] run function pack_manager:control/main_loop with storage pack_manager:user pack_info[-1]
##


## TELLRAW MANAGER TIME
    execute store result score #sync.temp pack_manager.data run stopwatch query zleinad_pack_manager:load 1000
    tellraw @a[tag=pack_manager.admin] [ \
        {"text":"[+] ",color:"white"},{translate:"leinad.pack_manager.load_manager_time.tellraw",fallback:"Pack manager loaded in %1$s ms", \
            with:[{score:{name:"#sync.temp",objective:"pack_manager.data"},color:"dark_gray"}],color:"gray"}, \
    ]
##

## REGULAR LOAD EXECUTION
    function #z_pack_manager:load
##

## TELLRAW TOTAL TIME
    execute store result score #pack_manager.load pack_manager.data run stopwatch query zleinad_pack_manager:load 1000
    tellraw @a[tag=pack_manager.admin] [ \
        {"text":"[^] ",color:"white"},{translate:"leinad.pack_manager.load_global_time.tellraw",fallback:"Executed %1$s in %2$s ms", \
            with:[{text:"#load",color:"aqua"},{score:{name:"#pack_manager.load",objective:"pack_manager.data"},color:"dark_gray"}],color:"gray"} \
    ]
##

## REMOVE TEMP DATA 2
    scoreboard players reset #pack_manager.load pack_manager.data
    data remove storage pack_manager:data temp
##

