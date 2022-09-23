function FiveCloudSDK:FiveCloudGameInit()
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(FiveCloudGameEvents, "OnGameRulesStateChange"),
        FiveCloudGameEvents) -- 监听游戏进程
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(FiveCloudEvent, "OnNPCSpawned"), FiveCloudEvent) -- 监听单位生成
    ListenToGameEvent("entity_killed", Dynamic_Wrap(FiveCloudEvent, "OnEntityKilled"), FiveCloudEvent) -- 监听单位死亡

    CustomGameEventManager:RegisterListener("fiveCloud_resetHero", Dynamic_Wrap(FiveCloudCustomEvent, "ResetHero"))
    CustomGameEventManager:RegisterListener("fiveCloud_levelUp", Dynamic_Wrap(FiveCloudCustomEvent, "LevelUp"))
    CustomGameEventManager:RegisterListener("fiveCloud_maxLevelUp", Dynamic_Wrap(FiveCloudCustomEvent, "MaxLevel"))
    CustomGameEventManager:RegisterListener("fiveCloud_setGold", Dynamic_Wrap(FiveCloudCustomEvent, "SetGold"))
    CustomGameEventManager:RegisterListener("fiveCloud_clearInventory",
        Dynamic_Wrap(FiveCloudCustomEvent, "ClearInventory"))
    CustomGameEventManager:RegisterListener("fiveCloud_respawnHero", Dynamic_Wrap(FiveCloudCustomEvent, "RespawnHero"))
    CustomGameEventManager:RegisterListener("fiveCloud_addHero", Dynamic_Wrap(FiveCloudCustomEvent, "AddHero"))
    CustomGameEventManager:RegisterListener("fiveCloud_replaceHero", Dynamic_Wrap(FiveCloudCustomEvent, "ReplaceHero"))
    CustomGameEventManager:RegisterListener("fiveCloud_getAbilityPoint",
        Dynamic_Wrap(FiveCloudCustomEvent, "GetAbilityPoint"))
    CustomGameEventManager:RegisterListener("fiveCloud_removeAbilityPoint",
        Dynamic_Wrap(FiveCloudCustomEvent, "RemoveAbilityPoint"))
    CustomGameEventManager:RegisterListener("fiveCloud_getHeroInfoStart",
        Dynamic_Wrap(FiveCloudCustomEvent, "GetHeroInfoStart"))
    CustomGameEventManager:RegisterListener("fiveCloud_getHeroInfoEnd",
        Dynamic_Wrap(FiveCloudCustomEvent, "GetHeroInfoEnd"))
    CustomGameEventManager:RegisterListener("fiveCloud_getAblityKVByAblityName",
        Dynamic_Wrap(FiveCloudCustomEvent, "GetAblityKVByAblityName"))
    CustomGameEventManager:RegisterListener("fiveCloud_getHeroKVByHeroName",
        Dynamic_Wrap(FiveCloudCustomEvent, "GetHeroKVByHeroName"))
    CustomGameEventManager:RegisterListener("fiveCloud_getUnitKVByUnitName",
        Dynamic_Wrap(FiveCloudCustomEvent, "GetUnitKVByUnitName"))
    CustomGameEventManager:RegisterListener("fiveCloud_refreshHero", Dynamic_Wrap(FiveCloudCustomEvent, "RefreshHero"))
    CustomGameEventManager:RegisterListener("fiveCloud_addDummyTarget",
        Dynamic_Wrap(FiveCloudCustomEvent, "AddDummyTarget"))
    CustomGameEventManager:RegisterListener("fiveCloud_createUnit", Dynamic_Wrap(FiveCloudCustomEvent, "CreateUnit"))
    CustomGameEventManager:RegisterListener("fiveCloud_selfMutilation",
        Dynamic_Wrap(FiveCloudCustomEvent, "SelfMutilation"))
    CustomGameEventManager:RegisterListener("fiveCloud_moveTo", Dynamic_Wrap(FiveCloudCustomEvent, "MoveTo"))
    CustomGameEventManager:RegisterListener("fiveCloud_removeUnit", Dynamic_Wrap(FiveCloudCustomEvent, "RemoveUnit"))
    CustomGameEventManager:RegisterListener("fiveCloud_invulnerability",
        Dynamic_Wrap(FiveCloudCustomEvent, "Invulnerability"))
    CustomGameEventManager:RegisterListener("fiveCloud_spawnRuneDoubleDamagePressed",
        Dynamic_Wrap(FiveCloudCustomEvent, "SpawnRuneDoubleDamagePressed"))
    CustomGameEventManager:RegisterListener("fiveCloud_spawnRuneHastePressed",
        Dynamic_Wrap(FiveCloudCustomEvent, "SpawnRuneHastePressed"))
    CustomGameEventManager:RegisterListener("fiveCloud_spawnRuneIllusionPressed",
        Dynamic_Wrap(FiveCloudCustomEvent, "SpawnRuneIllusionPressed"))
    CustomGameEventManager:RegisterListener("fiveCloud_spawnRuneInvisibilityPressed",
        Dynamic_Wrap(FiveCloudCustomEvent, "SpawnRuneInvisibilityPressed"))
    CustomGameEventManager:RegisterListener("fiveCloud_spawnRuneRegenerationPressed",
        Dynamic_Wrap(FiveCloudCustomEvent, "SpawnRuneRegenerationPressed"))
    CustomGameEventManager:RegisterListener("fiveCloud_spawnRuneArcanePressed",
        Dynamic_Wrap(FiveCloudCustomEvent, "SpawnRuneArcanePressed"))
    CustomGameEventManager:RegisterListener("fiveCloud_setCameraDistanceDialog",
        Dynamic_Wrap(FiveCloudCustomEvent, "SetCameraDistanceDialog"))
    CustomGameEventManager:RegisterListener("fiveCloud_dayNightCycle",
        Dynamic_Wrap(FiveCloudCustomEvent, "DayNightCycle"))
    CustomGameEventManager:RegisterListener("fiveCloud_pauseDayNightCycle",
        Dynamic_Wrap(FiveCloudCustomEvent, "PauseDayNightCycle"))
    CustomGameEventManager:RegisterListener("fiveCloud_easyBuy", Dynamic_Wrap(FiveCloudCustomEvent, "easyBuy"))
    CustomGameEventManager:RegisterListener("fiveCloud_freeSpells", Dynamic_Wrap(FiveCloudCustomEvent, "FreeSpells"))
    CustomGameEventManager:RegisterListener("fiveCloud_heroFastRespawn",
        Dynamic_Wrap(FiveCloudCustomEvent, "heroFastRespawn"))
    CustomGameEventManager:RegisterListener("fiveCloud_heroSituRespawn",
        Dynamic_Wrap(FiveCloudCustomEvent, "heroSituRespawn"))
    CustomGameEventManager:RegisterListener("fiveCloud_passiveGold", Dynamic_Wrap(FiveCloudCustomEvent, "PassiveGold"))
    CustomGameEventManager:RegisterListener("fiveCloud_noFogOfWar", Dynamic_Wrap(FiveCloudCustomEvent, "NoFogOfWar"))
    CustomGameEventManager:RegisterListener("fiveCloud_cl_particle_log_creates", Dynamic_Wrap(FiveCloudCustomEvent, "ParticleLogCreates"))

    CustomGameEventManager:RegisterListener("fiveCloud_sendToServerConsole",
        Dynamic_Wrap(FiveCloudCustomEvent, "SendToServerConsole"))

    CustomGameEventManager:RegisterListener("feedback", Dynamic_Wrap(FiveCloudCustomEvent, "feedback"))

    LinkLuaModifier("lm_take_no_damage", "five_cloud/modifier/lm_take_no_damage", LUA_MODIFIER_MOTION_NONE)
end
