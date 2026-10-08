data modify storage pack_manager:user pack_info append value { \
    "pack_id": "test_pack-2", \
    "pack_version": [I;1,0,0], \
    "load_before": [], \
    "load_after": [ \
        {"pack_id": "test_pack-3"}, \
    ], \
    "requires": [ \
        {"pack_id": "required_pack"}, \
    ] \
}

data modify storage pack_manager:user pack_info[-1].pack_version[0] set compute default integer z_pack_manager:version/test_pack-2/major
data modify storage pack_manager:user pack_info[-1].pack_version[1] set compute default integer z_pack_manager:version/test_pack-2/minor
data modify storage pack_manager:user pack_info[-1].pack_version[2] set compute default integer z_pack_manager:version/test_pack-2/patch