(function () {
  // 初始化更换技能面板
  for (let i = 0; i < GameUI.FiveCloudConfig.heroMaxAbilityNum - 1; i++) {
    existingAbilityPanel = $.CreatePanel('Panel', $("#fiveCloud_entinfoAbilityExisting"), '')
    existingAbilityPanel.AddClass('fiveCloud_entinfoAbilityPanel')
    existingAbilityPanel.BLoadLayoutSnippet('fiveCloud_entinfoAbilityExisting')
    existingAbilityPanel.visible = false
  }
})();

var v2Schedule = null
var v2ThinkStatus = false
var heroInfo = null
var prevEnt = null

GameEvents.Subscribe("fiveCloud_updateServerStatus", UpdateServerStatus);

function UpdateServerStatus(data) {
  if (data.name == "fiveCloud_entInfo" && data.data) {
    fiveCloud_entInfoThink()
  }
  if (data.name == "fiveCloud_entInfo" && data.data == false) {
    if (v2ThinkStatus) {
      $.CancelScheduled(v2Schedule)
      v2ThinkStatus = false
    }
  }
}

function fiveCloud_entinfoClose() {
  GameUI.FiveCloudInfoPanel.fiveCloud_entinfo.AddClass('minimized')
  if (v2ThinkStatus) {
    $.CancelScheduled(v2Schedule)
    v2ThinkStatus = false
  }
  FiveCloudFireCustomGameEvent('fiveCloud_getHeroInfoEnd', {})
}

function fiveCloud_entInfoThink() {
  let ThinkInterval = 0
  v2ThinkStatus = true

  let ent = Players.GetLocalPlayerPortraitUnit()

  if (ent != prevEnt) {
    heroInfo = null
    prevEnt = ent
    FiveCloudFireCustomGameEvent('fiveCloud_getHeroInfoStart', { ent: ent , first: false })
  }

  if (ent && ent != -1) {
    UpdateBuffs(ent)
    UpdateAbility(ent)

    heroInfo = CustomNetTables.GetTableValue("fiveCloud_heroInfo", "entText")

    $("#entId").text = ent
    $("#GetUnitName").text = Entities.GetUnitName(ent)
    $("#GetClassNameAsCStr").text = Entities.GetClassNameAsCStr(ent)
    let tempAbsOrigin = Entities.GetAbsOrigin(ent).toString().split(',')
    $("#GetAbsOrigin").text = parseFloat(tempAbsOrigin[0]).toFixed(2) + ' | ' + parseFloat(tempAbsOrigin[1]).toFixed(2) + ' | ' + parseFloat(tempAbsOrigin[2]).toFixed(2)
    $("#GetDayTimeVisionRange").text = Entities.GetDayTimeVisionRange(ent)
    $("#GetNightTimeVisionRange").text = Entities.GetNightTimeVisionRange(ent)
    $("#GetBaseAttackTime").text = Entities.GetBaseAttackTime(ent).toFixed(2)
    $("#GetAttackSpeed").text = (Entities.GetAttackSpeed(ent) * 100).toFixed(0)
    $("#GetAttacksPerSecond").text = Entities.GetAttacksPerSecond(ent).toFixed(2)
    $("#GetHullRadius").text = Entities.GetHullRadius(ent).toFixed(2)
    $("#GetPaddedCollisionRadius").text = Entities.GetPaddedCollisionRadius(ent).toFixed(2)

    if (heroInfo != null) {
      $("#GetAttackAnimationPoint").text = heroInfo.GetAttackAnimationPoint.toFixed(2)
      $("#GetCooldownReduction").text = heroInfo.GetCooldownReduction.toFixed(2)
      $("#GetCastPoint").text = heroInfo.GetCastPoint.toFixed(2)
      $("#GetIdealSpeed").text = heroInfo.GetIdealSpeed.toFixed(0)
      $("#GetProjectileSpeed").text = heroInfo.GetProjectileSpeed.toFixed(0)
      let tempAbsOrigin2 = heroInfo.GetAbsOrigin.split(' ')
      $("#GetAbsOrigin2").text = parseFloat(tempAbsOrigin2[0]).toFixed(2) + ' | ' + parseFloat(tempAbsOrigin2[1]).toFixed(2) + ' | ' + parseFloat(tempAbsOrigin2[2]).toFixed(2)
      $("#GetAverageTrueAttackDamage").text = heroInfo.GetAverageTrueAttackDamage
      $("#GetDamage").text = heroInfo.GetBaseDamageMin + ' - ' + heroInfo.GetBaseDamageMax
      $("#GetPhysicalArmorValue").text = heroInfo.GetPhysicalArmorValue.toFixed(2)
      $("#GetMagicalArmorValue").text = (heroInfo.GetMagicalArmorValue * 100).toFixed(2) + '%'
    } else {
      $("#GetAttackAnimationPoint").text = '-'
      $("#GetCooldownReduction").text = '-'
      $("#GetCastPoint").text = '-'
      $("#GetIdealSpeed").text = '-'
      $("#GetProjectileSpeed").text = '-'
      $("#GetAbsOrigin2").text = '-'
      $("#GetAverageTrueAttackDamage").text = '-'
      $("#GetDamage").text = '-'
      $("#GetPhysicalArmorValue").text = '-'
      $("#GetMagicalArmorValue").text = '-'
    }
  }

  v2Schedule = $.Schedule(ThinkInterval, fiveCloud_entInfoThink)

  let checked = !$('#fiveCloud_entinfo').BHasClass('minimized')
  if (!checked) {
    fiveCloud_entinfoClose()
  }
}


function UpdateBuffs(unit) {

  var nBuffs = Entities.GetNumBuffs(unit);
  var BuffList = $("#BuffList");

  $("#BuffList").BLoadLayout("", false, false)

  for (var i = 0; i < nBuffs; i++) {
    var buffSerial = Entities.GetBuff(unit, i);
    if (buffSerial == -1)
      continue;

    let buffPanel = $.CreatePanel('Panel', BuffList, '');
    buffPanel.AddClass('fiveCloud_entinfoRow')
    let buffLabel = $.CreatePanel('Label', buffPanel, '');
    buffLabel.AddClass('fiveCloud_entinfoCowRight')
    let buffLabelText = "";
    let buffName = Buffs.GetName(unit, buffSerial);
    buffLabelText += buffName;
    let GetStackCount = Buffs.GetStackCount(unit, buffSerial);
    if (GetStackCount > 0) {
      buffLabelText += " (" + GetStackCount + ")";
    }
    let GetDuration = Buffs.GetDuration(unit, buffSerial);
    let GetRemainingTime = Buffs.GetRemainingTime(unit, buffSerial).toFixed(2);

    if (GetDuration > 0) {
      buffLabelText += " | " + GetRemainingTime;
    }

    buffLabel.text = buffLabelText
  }
}

function UpdateAbility(ent) {
  let AbilityCount = Entities.GetAbilityCount(ent)
  for (let i = 0; i < AbilityCount; i++) {
    let abilityid = Entities.GetAbility(ent, i)
    let abilityPanel = $("#fiveCloud_entinfoAbilityExisting").GetChild(i)
    if (abilityid == -1) {
      abilityPanel.visible = false
    } else {

      let abilityImg = abilityPanel.GetChild(0)
      let abilityname = Abilities.GetAbilityName(abilityid)

      abilityImg.contextEntityIndex = abilityid

      if (abilityname.indexOf('special_bonus_') >= 0 || abilityname == "generic_hidden" || abilityname == "") {
        abilityPanel.visible = false
      } else {
        abilityPanel.visible = true
        abilityImg.SetPanelEvent("onmouseover", function () {
          $.DispatchEvent("DOTAShowAbilityTooltip", abilityImg, abilityname)
        })
        abilityImg.SetPanelEvent("onmouseout", function () {
          $.DispatchEvent("DOTAHideAbilityTooltip")
        })
        abilityImg.SetPanelEvent("onactivate", function () {
          FiveCloudFireCustomGameEvent('fiveCloud_getAblityKVByAblityName', { abilityName: abilityname })
        })
      }
    }
  }
}