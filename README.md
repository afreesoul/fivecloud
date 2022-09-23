## FiveCloudSdk

content需要在custom_ui_manifest.xml引入
<CustomUIElement type="Hud" layoutfile="file://{resources}/layout/custom_game/five_cloud/main/index.xml" />

game可以在addon_game_mode.lua中引入
require("five_cloud.index")

然后在InitGameMode中初始化
FiveCloudSDK:FiveCloudGameInit()

