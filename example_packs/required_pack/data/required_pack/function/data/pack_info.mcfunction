data modify storage pack_manager:user pack_info append value { \
    "pack_id": "required_pack", \
    "pack_version": [I;0,0,0], \
    "load_before": [], \
    "load_after": [], \
    "requires": [] \
}

data modify storage pack_manager:user pack_info[-1].pack_version[0] set compute default integer z_pack_manager:version/required_pack/major
data modify storage pack_manager:user pack_info[-1].pack_version[1] set compute default integer z_pack_manager:version/required_pack/minor
data modify storage pack_manager:user pack_info[-1].pack_version[2] set compute default integer z_pack_manager:version/required_pack/patch