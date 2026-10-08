data modify storage pack_manager:user pack_info append value { \
    "pack_id": "test_pack-5", \
    "pack_version": [I;0], \
    "load_before": [], \
    "load_after": [ \
        {"pack_id": "test_pack-4"}, \
    ], \
    "requires": [] \
}

data modify storage pack_manager:user pack_info[-1].pack_version[0] set compute default integer z_pack_manager:version/test_pack-5/major