# Inter-Datapack detection and automatic dependency management

> [!IMPORTANT]
> As this is designed to take use of number providers, it will only work from 26.3 onwards!

This repository aims to provide with a standard protocol for inter-datapack cooperation as well as an example implementation of a library prepared to manage automatically all compatible packs in a more optimized way by ~~hijacking the default `#load` function while operating and~~ doing all the dependency checks at once.

> [!TIP]
> If you can control over the enviroment where your packs will be installed, you may make your own implementation of this manager. This one is prepared for debugging purposes with a player tag `pack_manager.admin` for tellraw info, a multi-step `#load` and plans for controlling the order of installed packs. 


The information below describes only the protocol for version detection and pack manager behaviour, the specifics of the implementation will be defined inside the README of the manager itself.

> [!NOTE]
> Most pack examples and the pack manager itself are still being implemented, but `_pack_manager`, `external_pack`, `required_pack` and `test_pack-1` are already prepared for testing out the protocol.


## Protocol specification

### Pack metadata, dependencies and loading

Every pack, should do 3 things to be compatible. Provide it's own data, specify it's dependencies and, at minimum, manage them. It can optionally give support for the usage of the library (which is encouraged, as it can also detect duplicate packs) 

#### Metadata

The pack should provide others of the following data:

```cs
{
    pack_id : string,       // <> identifier of the pack, must not change over versions! <>
    
    version : [             // <> ---- ---- ---- -- version of the pack -- ---- ---- ---- <>
        major : int,        // <> Major is required to be greater or equal than 0.        <>
        minor : int,        // <> Both minor and patch are optional, but patch can        <>
        patch : int         // <> only be present if minor is. Set via number providers.  <>
    ],                      // <> ---- ---- ---- ---- ---- -- -- ---- ---- ---- ---- ---- <>

    requires : [            // <> Pack ids that this pack requires to exist.              <>
        {pack_id : string}  // <> Version/presence requirements can be handled freely via <>
    ]                       // <> predicates and the version number providers of packs    <>
}
```

##### **`pack_id`**

Provided on the documentation of your pack. It should **never** change and will be used to identify it.

##### **`version`**

Specified via number providers. 1 Integer mode provider per level of granularity provided, until 3 (major, minor, patch).

Their resource id's and contents for a pack whose version is `X.Y.Z` would be the following:

At `z_pack_manager:version/<pack_id>/major`:
```json
X
```

At `z_pack_manager:version/<pack_id>/minor`:
```json
Y
```

At `z_pack_manager:version/<pack_id>/patch`:
```json
Z
```

Then, number provider tags with the same ids should be made to ensure that predicates are allowed by other datapacks to check when it is not on the world:

At `#z_pack_manager:version/<pack_id>/major`:
```json
{
    "values":[
        "z_pack_manager:version/<pack_id>/major"
    ]
}
```

At `#z_pack_manager:version/<pack_id>/minor`:
```json
{
    "values":[
        "z_pack_manager:version/<pack_id>/minor"
    ]
}
```

At `#z_pack_manager:version/<pack_id>/patch`:
```json
{
    "values":[
        "z_pack_manager:version/<pack_id>/patch"
    ]
}
```


#### Dependencies and pack manager support

##### **`requires[]`**

Provided on the documentation of your pack. This field requires you to implement it. To check for a version you should use predicates that check the target's version number providers.

For example, if I want to check that `<required_pack>` is on major:1 and it's minor version is equal or greater than 2, you would have the following predicate:

```json
{
    "type": "minecraft:all_of",
    "terms": [
        {
            "type": "minecraft:int_value_check",
            "value": {
                "type": "minecraft:max",
                "inputs": "#z_pack_manager:version/<required_pack>/major"
            },
            "test": 1
        },
        {
            "type": "minecraft:int_value_check",
            "value": {
                "type": "minecraft:max",
                "inputs": "#z_pack_manager:version/<required_pack>/minor"
            },
            "test": {
                "min": 2
            }
        }
    ]
}
```

As you may have guessed, this requires you to define both major and minor tags (as empty ones) on the pack with the dependency, as the lack of definition would cause the game to refuse to load the datapack. Then, whenever `<required_pack>` is enabled on the world, the tags would add the number providers and then provide the proper version. The operation for the checks should be `minecraft:max`, as it allows you to add a number provider **for the major version** (that's why it is mandatory!) that gives the constant `-1`, and then you can just check if it satisfies `"test":{"min":0}` on the predicate. Those dummy definitions should be made on your pack's namespace to avoid conflicts.

##### Checking for hard dependencies

If your pack requires the existance of another pack, your best bet would be to do those checks on `#load` and disable yourself if they cannot be matched. The library, provides a safe entrypoint for this.

It's implementation, allows for having different functions get called on `#load` depending on if the pack manager is present or not. To use them, you must follow these steps:

##### 1. Changes on `#minecraft:load`

Your `#minecraft:load` tag definition should look like this:

```json
{
    "values": [
        {
            "id": "#z_pack_manager:__conditional__/load",
            "required": false
        }
    ]
}
```

> You can probably figure out why that `"required": false` is there. This tag will not run when the library gets loaded.
> It does this by placing itself at the end of the loaded list automatically and adding a filtered function to the tag, which makes it invalid.

Then, you'll need 2 tags: the already mentioned `#z_pack_manager:__conditional__/load` and `#z_pack_manager:load`.

**`#z_pack_manager:__conditional__/load`:**
> This tag must contain `#z_pack_manager:load` and all the functions you want to run when there is no pack manager present.  
> Feel free to use `z_pack_manager/function/load/<pack_id>`, as the library provides more reserved triggers on the `z_pack_manager` namespace, and this will help to group the library behaviour contained. This path specifically is filtered by the library, so that it will not consume resources when it's present.

**`#z_pack_manager:load`**
> Treat this tag as the vanilla `#minecraft:load`, it executes both when the library is loaded and when the vanilla execution takes place. The library entrypoint will only execute after no dependencies have been found to fail.

##### 2. Validating dependencies

> [!NOTE]
> You can check the dependencies by yourself inside `#z_pack_manager:load`, which is not recommended as it could cause a slowdown on load.

The proper way for this part would be to separate the checks depending on the presence of the library. Inside `z_pack_manager:load/<pack_id>` (on the conditional tag) you would be the one in charge of checking dependencies and errors. When the library loads on the other hand, information about the pack will be requested by the pack manager via the `#z_pack_manager:get_pack_info` tag. During the execution of this tag, compatible packs should append to `storage pack_manager:user pack_info` a compound with their data, using the format specified before:

```cs
{
    pack_id : string,       // <> identifier of the pack, must not change over versions! <>
    
    version : [             // <> ---- ---- ---- -- version of the pack -- ---- ---- ---- <>
        major : int,        // <> For duplicate pack checking by the library.             <>
        minor : int,        // <> You should use predicates + the number provider methods <>
        patch : int         // <> for detection instead.                                  <>
    ],                      // <> ---- ---- ---- ---- ---- -- -- ---- ---- ---- ---- ---- <>

    requires : [            // <> Pack ids that this pack requires to exist.              <>
        {pack_id : string}  // <> If a pack is specified here, the predicate used will be <>
    ]                       // <> `z_pack_manager:depends/<pack_id>/<required_id>`        <>
}
```

As the comments specify, packs should only include the `<required_pack>` id on the compounds inside `requires`, and then, a predicate for this specific dependency at `z_pack_manager:depends/<pack_id>/<required_id>`. 

If a dependency fails, it will then call `z_pack_manager:error/<pack_id>` with the data inside the `requires` index that caused the error. At this moment, contents of `storage pack_manager:user pack_info[-1].requires` are the provided ones on the `[0,FAIL_IDX]` range, with an extra field set: `checking`, which equals the provided `<pack_id>` of your pack.  
You are the one in charge of disabling your pack after this moment. The provided examples disable themselves by checking against:

- `'"file/<pack_name>"'`
- `'"file/<pack_name>.zip"'`

... which are the standard paths that datapacks will be loaded as depending on if they are directories or zips, but more formats may exist, you are the one in charge of this part, if your pack is made for worldgen or uses other experimental features, you need to consider that disabling the pack will not remove the registries for them until a hard reload (closing and reopening the world).