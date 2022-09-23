(function () {
    $("#fiveCloud_easyBuy").checked = true
    FiveCloudFireToggleEvent('fiveCloud_easyBuy')

    $("#fiveCloud_heroFastRespawn").checked = true
    FiveCloudFireToggleEvent('fiveCloud_heroFastRespawn')

    $("#fiveCloud_heroSituRespawn").checked = true
    FiveCloudFireToggleEvent('fiveCloud_heroSituRespawn')
})();

function fiveCloud_toolClose() {
    $("#fiveCloud_toolContainer").AddClass('minimized')
}

function fiveCloud_addHero(isFriend) {
    if (isFriend) {
        GameUI.CurrentAction = 'AddHeroIsFriend'
    } else {
        GameUI.CurrentAction = 'AddHeroIsEnemy'
    }

    ToggleHeroPicker()
}

function fiveCloud_replaceHero() {
    GameUI.CurrentAction = 'ReplaceHero'
    ToggleHeroPicker()
}

var prevAction = null
function ToggleHeroPicker() {
    let checked = !GameUI.FiveCloudPickPanel.fiveCloud_heropick.BHasClass('minimized')

    if (checked) {
        if (prevAction != GameUI.CurrentAction) {
            GameUI.MouseClickListen = true
            FiveCloudHidePanel('FiveCloudPickPanel', 'fiveCloud_heropick')
            $.Schedule(0.2, function () {
                FiveCloudOpenPanel('FiveCloudPickPanel', 'fiveCloud_heropick')
            })
        } else {
            FiveCloudHidePanel('FiveCloudPickPanel', 'fiveCloud_heropick')
        }
    } else {
        GameUI.MouseClickListen = true
        FiveCloudOpenPanel('FiveCloudPickPanel', 'fiveCloud_heropick')
    }

    prevAction = GameUI.CurrentAction
}

function fiveCloud_entInfo() {
    let checked = $('#fiveCloud_entInfo').checked
    if (checked) {
        FiveCloudOpenPanel('FiveCloudInfoPanel', 'fiveCloud_entinfo')
        $('#fiveCloud_showKV').checked = false
        let ent = Players.GetLocalPlayerPortraitUnit()
        FiveCloudFireCustomGameEvent('fiveCloud_getHeroInfoStart', { ent: ent, first: true })
    } else {
        FiveCloudHidePanel('FiveCloudInfoPanel', 'fiveCloud_entinfo')
        FiveCloudFireCustomGameEvent('fiveCloud_getHeroInfoEnd', {})
    }
}

function fiveCloud_showKV() {
    let checked = $('#fiveCloud_showKV').checked
    if (checked) {
        FiveCloudOpenPanel('FiveCloudInfoPanel', 'fiveCloud_entkv')
        $('#fiveCloud_entInfo').checked = false
        let ent = Players.GetLocalPlayerPortraitUnit()
        let unitName = Entities.GetUnitName(ent)
        if (Entities.IsHero(ent)) {
            FiveCloudFireCustomGameEvent('fiveCloud_getHeroKVByHeroName', { unitName: unitName, first: true  })
        } else {
            $.Msg(unitName)
            FiveCloudFireCustomGameEvent('fiveCloud_getUnitKVByUnitName', { unitName: unitName, first: true  })
        }
    } else {
        FiveCloudHidePanel('FiveCloudInfoPanel', 'fiveCloud_entkv')
    }
}

function fiveCloud_addUnit(isFriend) {
    if (isFriend) {
        GameUI.CurrentAction = 'AddUnitIsFriend'
    } else {
        GameUI.CurrentAction = 'AddUnitIsEnemy'
    }

    ToggleUnitPicker()
}

function ToggleUnitPicker() {
    let checked = !GameUI.FiveCloudPickPanel.fiveCloud_unitpick.BHasClass('minimized')

    if (checked) {
        if (prevAction != GameUI.CurrentAction) {
            GameUI.MouseClickListen = true
            FiveCloudHidePanel('FiveCloudPickPanel', 'fiveCloud_unitpick')
            $.Schedule(0.2, function () {
                FiveCloudOpenPanel('FiveCloudPickPanel', 'fiveCloud_unitpick')
            })
        } else {
            FiveCloudHidePanel('FiveCloudPickPanel', 'fiveCloud_unitpick')
        }
    } else {
        GameUI.MouseClickListen = true
        FiveCloudOpenPanel('FiveCloudPickPanel', 'fiveCloud_unitpick')
    }

    prevAction = GameUI.CurrentAction
}

var arrowParticle = null
var mtpSchedule = null
var mtpThinkStatus = false

function fiveCloud_moveToPoint() {
    GameUI.MouseClickListen = true
    GameUI.MouseClickStatus = 'MoveToPoint'

    var entindex = Players.GetLocalPlayerPortraitUnit()

    if (arrowParticle != null) {
        Particles.DestroyParticleEffect(arrowParticle, true)
        Particles.ReleaseParticleIndex(arrowParticle);
    }
    arrowParticle = Particles.CreateParticle("panorama/layout/custom_game/five_cloud/particles/selection/selection_grid_drag.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, entindex);

    const origin = Entities.GetAbsOrigin(entindex);

    origin[2] += 50;
    Particles.SetParticleControl(arrowParticle, 4, origin);

    Particles.SetParticleAlwaysSimulate(arrowParticle);

    MoveToParticlesThink()
}

function MoveToParticlesThink() {
    var entindex = Players.GetLocalPlayerPortraitUnit()
    if (GameUI.MouseClickListen) {
        var coordinates = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition())

        const origin = Entities.GetAbsOrigin(entindex)
        origin[2] += 50;
        Particles.SetParticleControl(arrowParticle, 4, origin);
        Particles.SetParticleControl(arrowParticle, 5, coordinates)
        Particles.SetParticleControl(arrowParticle, 2, [128, 128, 128]);

        mtpSchedule = $.Schedule(0, MoveToParticlesThink)
    } else {
        Particles.DestroyParticleEffect(arrowParticle, true)
        Particles.ReleaseParticleIndex(arrowParticle);
        Particles.CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_end_b.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, entindex);
    }
}

function MouseOverRune(strRuneID, strRuneTooltip) {
    var runePanel = $('#' + strRuneID);
    runePanel.StartAnimating();
    // 触发ToolTip
    $.DispatchEvent('UIShowTextTooltip', runePanel, strRuneTooltip);
}

function MouseOutRune(strRuneID) {
    var runePanel = $('#' + strRuneID);
    runePanel.StopAnimating();
    // 触发ToolTip
    $.DispatchEvent('UIHideTextTooltip', runePanel);
}

function fiveCloud_dota_launch_custom_game(){
    let command = "dota_launch_custom_game " + GameUI.FiveCloudConfig.gameName + " " + GameUI.FiveCloudConfig.mapName
    FiveCloudFireCustomGameEvent('fiveCloud_sendToServerConsole', { command: command})
}



GameEvents.Subscribe("fiveCloud_updateServerStatus", UpdateServerStatus);

function UpdateServerStatus(data) {
    if (data.data == 1) {
        $('#' + data.name).checked = true
    } else {
        $('#' + data.name).checked = false
    }
}