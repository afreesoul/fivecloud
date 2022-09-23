(function () {

})();

function fiveCloud_createUnit(unit) {
  FiveCloudHidePanel('FiveCloudPickPanel', 'fiveCloud_unitpick')

  if (GameUI.CurrentAction == 'AddUnitIsFriend') {
      FiveCloudFireCustomGameEvent('fiveCloud_createUnit', { unit: unit, isFriend: true })
  }
  if (GameUI.CurrentAction == 'AddUnitIsEnemy') {
      FiveCloudFireCustomGameEvent('fiveCloud_createUnit', { unit: unit, isFriend: false })
  }
}