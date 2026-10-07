data modify storage pack_manager:user pack_info append value { \
    "pack_id": "test_pack-5", \
    "pack_version": [I;1,0,0], \
    "load_before": [], \
    "load_after": [ \
        {"pack_id": "test_pack-4"}, \
    ], \
    "requires": [] \
}