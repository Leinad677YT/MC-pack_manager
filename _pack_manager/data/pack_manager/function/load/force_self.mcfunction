datapack disable "file/_pack_manager"
datapack enable "file/_pack_manager" last

datapack disable "file/_pack_manager.zip"
datapack enable "file/_pack_manager.zip" last

tellraw @a[tag=pack_manager.admin] [{text:"[!] ",color:"#bb7722"},{translate:"leinad.pack_manager.previous_last_pack.tellraw",fallback:"Previous last loaded pack was %1$s",with:[{storage:"pack_manager:data",nbt:"temp.last",interpret:false,color:"white"}],color:"#ff9922"}]
tellraw @a[tag=pack_manager.admin] [{text:"[!] ",color:"#bb7722"},{translate:"leinad.pack_manager.repositioned.tellraw",fallback:"Pack manager repositioned itself",color:"#ff9922"}]