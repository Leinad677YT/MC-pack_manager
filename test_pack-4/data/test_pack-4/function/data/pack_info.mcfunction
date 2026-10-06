data modify storage pack_manager:user pack_info append value { \
    "pack_id": "test_pack-4", \
    "pack_version": [I;1,0,0], \
    "load_before": [ \
    ], \
    "load_after": [ \
        {"pack_id": "test_pack-3"}, \
        {"pack_id": "test_pack-1"}, \
    ], \
    "requires": [ \
        {"pack_id": "required_pack", "version":[I;0,12,1]}, \
    ] \
}