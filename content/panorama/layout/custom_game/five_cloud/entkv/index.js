(function () {

})();

var ShowKVSchedule = null
var ShowKVThinkStatus = false
var prevEnt = null

GameEvents.Subscribe("fiveCloud_toHeroKVByName", ToHeroKVByName)
GameEvents.Subscribe("fiveCloud_toAbilityKVByName", ToAbilityKVByName)

function fiveCloud_entkvClose() {
  GameUI.FiveCloudInfoPanel.fiveCloud_entkv.AddClass('minimized')
  if (ShowKVThinkStatus) {
    $.CancelScheduled(ShowKVSchedule)
    ShowKVThinkStatus = false
    GameUI.FiveCloudPanel.fiveCloud_toolContainer.FindChildTraverse('fiveCloud_showKV').checked = false
  }
}

function fiveCloud_entkvThink() {
  let ThinkInterval = 0
  ShowKVThinkStatus = true

  let ent = Players.GetLocalPlayerPortraitUnit()

  if (ent != prevEnt) {
    
      prevEnt = ent
      let unitName = Entities.GetUnitName(ent)
      if (Entities.IsHero(ent)) {
          FiveCloudFireCustomGameEvent('fiveCloud_getHeroKVByHeroName', { unitName: unitName, first: false })
      } else {
          FiveCloudFireCustomGameEvent('fiveCloud_getUnitKVByUnitName', { unitName: unitName, first: false })
      }
  }

  ShowKVSchedule = $.Schedule(ThinkInterval, fiveCloud_entkvThink)

  let checked = !$('#fiveCloud_entkv').BHasClass('minimized')
  if (!checked) {
    fiveCloud_entkvClose()
  }
}

function ToHeroKVByName(data) {
  $.Msg('[ToHeroKVByName]')
  let HeroKVByName = data.data

  let ordered = {}
  Object.keys(HeroKVByName).sort().forEach(function (key) {
      ordered[key] = HeroKVByName[key];
  })
  $.Msg(ordered)

  let ent = Players.GetLocalPlayerPortraitUnit()
  prevEnt = ent

  $("#fiveCloud_showKVContent").BLoadLayout("", false, false)

  let entTextPanelCowCenter = $.CreatePanel('Label', $("#fiveCloud_showKVContent"), '')
  entTextPanelCowCenter.AddClass('fiveCloud_showKVCowCenter')
  entTextPanelCowCenter.text = Entities.GetUnitName(prevEnt)

  for (let key in ordered) {
      CreateShowKVPanel(key, HeroKVByName[key], $("#fiveCloud_showKVContent"))
  }

  if (!ShowKVThinkStatus) {
    fiveCloud_entkvThink()
  }
}

function ToAbilityKVByName(data) {
  $.Msg('[ToAbilityKVByName]')
  FiveCloudOpenPanel('FiveCloudInfoPanel', 'fiveCloud_entkv')
  let AbilityKVByName = data.data

  let ordered = {}
  Object.keys(AbilityKVByName).sort().forEach(function (key) {
      ordered[key] = AbilityKVByName[key];
  })
  $.Msg(ordered)

  $("#fiveCloud_showKVContent").BLoadLayout("", false, false)

  let entTextPanelCowCenter = $.CreatePanel('Label', $("#fiveCloud_showKVContent"), '')
  entTextPanelCowCenter.AddClass('fiveCloud_showKVCowCenter')
  entTextPanelCowCenter.text = data.abilityName

  for (let key in ordered) {
      CreateShowKVPanel(key, AbilityKVByName[key], $("#fiveCloud_showKVContent"))
  }

}

function CreateShowKVPanel(k, v, panel) {
  if (typeof (v) == 'object') {
      let entTextPanelRow = $.CreatePanel('Panel', panel, '')
      entTextPanelRow.AddClass('fiveCloud_showKVObject')
      let entTextPanelCow = $.CreatePanel('Panel', entTextPanelRow, '')
      entTextPanelCow.AddClass('fiveCloud_showKVRow')
      let entTextPanelCowCenter = $.CreatePanel('Label', entTextPanelCow, '')
      entTextPanelCowCenter.AddClass('fiveCloud_showKVCowCenter')
      entTextPanelCowCenter.text = k
      for (let key in v) {
          CreateShowKVPanel(key, v[key], entTextPanelRow)
      }
  } else {
      let entTextPanelRow = $.CreatePanel('Panel', panel, '')
      entTextPanelRow.AddClass('fiveCloud_showKVRow')
      let entTextPanelCow = $.CreatePanel('Panel', entTextPanelRow, '')
      entTextPanelCow.AddClass('fiveCloud_showKVCow')
      let entTextPanelCowLeft = $.CreatePanel('Label', entTextPanelCow, '')
      entTextPanelCowLeft.AddClass('fiveCloud_showKVCowLeft')
      entTextPanelCowLeft.text = k
      let entTextPanelCowRight = $.CreatePanel('Label', entTextPanelCow, '')
      entTextPanelCowRight.AddClass('fiveCloud_showKVCowRight')
      entTextPanelCowRight.text = v
  }
}
