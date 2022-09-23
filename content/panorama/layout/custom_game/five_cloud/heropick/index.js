(function () {
  $.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#fiveCloud_heropick'), SwitchToNewHero)
})();

function SwitchToNewHero(heroId) {
  $.Msg(GameUI.CurrentAction)
  if (GameUI.CurrentAction == 'ReplaceHero') {
    FiveCloudFireCustomGameEvent('fiveCloud_replaceHero', { heroId: heroId })
    GameUI.FiveCloudPickPanel.fiveCloud_heropick.AddClass('minimized')
  }
  if (GameUI.CurrentAction == 'AddHeroIsFriend') {
    FiveCloudFireCustomGameEvent('fiveCloud_addHero', { heroId: heroId, isFriend: true })
    GameUI.FiveCloudPickPanel.fiveCloud_heropick.AddClass('minimized')
  }
  if (GameUI.CurrentAction == 'AddHeroIsEnemy') {
    FiveCloudFireCustomGameEvent('fiveCloud_addHero', { heroId: heroId, isFriend: false })
    GameUI.FiveCloudPickPanel.fiveCloud_heropick.AddClass('minimized')
  }
}