data modify storage pack_manager:user pack_info append value { \
    "pack_id": "isolated_pack-1", \
    "pack_version": [I;0], \
    "load_before": [], \
    "load_after": [], \
    "requires": [] \
}

data modify storage pack_manager:user pack_info[-1].pack_version[0] set compute default integer z_pack_manager:version/isolated_pack-1/major