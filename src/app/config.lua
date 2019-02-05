require 'vendor.helper'
require 'app.card'
require 'app.dialog'
require 'app.game'
require 'app.support'
require 'app.NPCommand'
require 'app.ServantSkillCommand'
require 'app.MasterSkillCommand'
require 'app.SwitchServantCommand'

Config = {}

-- |------------------------------------------------------|
-- | Version Control                                      |
-- |------------------------------------------------------|
local updateURI = 'https://fgobot.pokeguy.me/update.json'
Config.API_URL = 'http://192.168.1.47:5000'
Config.API_KEY = '6a4b1540a07e4043b798f17d16dd53b3c34ba144b693e633f5b7696a5633c793'
Config.version = '0.0.1'
-- |------------------------------------------------------|
-- | Game Config > User Perference                        |
-- |------------------------------------------------------|
Config.perference = {}
Config.debugPath = scriptPath() .. '/debug/'
Config.imagePath = scriptPath() .. '/image/'
Config.runtimePath = scriptPath() .. '/runtime/'
-- |------------------------------------------------------|
-- | Game Config > AP Item                                |
-- |------------------------------------------------------|
Config.AP_AUTO_RECOVERY = 1
Config.AP_USE_GOLDEN_APPLE = 2
Config.AP_USE_SILVER_APPLE = 3
Config.AP_USE_COPPER_APPLE = 4
Config.AP_USE_SAINT_QUARTZ = 5
Config.AP = {
  'APClose.png',
  'appleGolden.png',
  'appleSilver.png',
  'appleBrozen.png',
  'SQ.png'
}
-- |------------------------------------------------------|
-- | Game Config > Friend                                 |
-- |------------------------------------------------------|
Config.SUPPORT_SERVANT_WAVER = 1
Config.SUPPORT_SERVANT_MERLIN = 2
Config.SUPPORT_SERVANT_SKADI = 3
Config.SUPPORT_CE_BOND = 1
Config.SUPPORT_CE_QP = 2
Config.SUPPORT_CE_EXP = 3
Config.SUPPORT_CE_DIRECTOR = 4
Config.SUPPORT_CE_NEW_DIRECTOR = 5
Config.SUPPORT_CE_KSCOPE = 6
Config.SKILL_LEVEL_LIST = { '1', '2', '3', '4', '5', '6', '7', '8', '9', '10' }
Config.SUPPORT_CE_LIST = {
    'bond_MLB.png',
    'QP_MLB.png',
    'EXP_MLB.png',
    'director_MLB.png',
    'new_director_MLB.png',
    'new_bond_MLB.png',
    'kscope_MLB.png',
    'custom.png'
}
Config.SUPPORT_SERVERT_LIST = {
    'waver.png',
    'merlin.png',
    'skadi.png',
}
-- |------------------------------------------------------|
-- | Game Config > Card Type                              |
-- |------------------------------------------------------|
Config.DEFAULT_CARD_ATTR = 'NONE'
Config.Buster = 'B'
Config.Arts = 'A'
Config.Quick = 'Q'
Config.Random = 'R'
Config.perferredType = {
    Config.Buster,
    Config.Buster,
    Config.Arts,
    Config.Quick,
    Config.Random
}
-- |------------------------------------------------------|
-- | Image Region > Home                                  |
-- |------------------------------------------------------|
Config.rQuest = Region(935, 230, 915, 250)
Config.rAPMsg = Region(250, 50, 1350, 935)
Config.rDialog = Region(260, 120, 1400, 840)
Config.rMenu = Region(1650, 960, 270, 120)
Config.rMenuClose = Region(1635, 730, 270, 120)
-- |------------------------------------------------------|
-- | Image Region > Friend                                |
-- |------------------------------------------------------|
Config.rBack = Region(0, 0, 200, 130)
Config.rFriendFunc = Region(0, 135, 1920, 115)
Config.rSupport01 = Region(70, 290, 1745, 285)
Config.rSupport02 = Region(70, 595, 1745, 285)
Config.rSupport03 = Region(70, 895, 1745, 160)
Config.rSupportCE = Region(85, 500, 225, 50)
Config.rQuestStart = Region(1650, 950, 270, 130)
-- |------------------------------------------------------|
-- | Image Region > Battle                                |
-- |------------------------------------------------------|
Config.rLoading = Region(1350, 930, 300, 150)
Config.rAttack = Region(1550, 770, 320, 300)
Config.rRound = Region(1295, 18, 25, 40)
Config.rEnemy = Region(1363, 73, 27, 35)
Config.rMasterSkill = Region(1750, 425, 100, 100)
Config.rSkillTarget = Region(720, 250, 490, 80)
Config.rBondMsg = Region(105, 240, 490, 80)
Config.rEXPMsg = Region(945, 240, 880, 680)
Config.rDropMsg = Region(130, 90, 1790, 990)
Config.rRewardMsg = Region(130, 90, 1790, 990)
Config.rFrdRequest = Region(130, 90, 1790, 990)
Config.rServantNP = {
    Region(242, 1018, 198, 1),
    Region(718, 1018, 198, 1),
    Region(1197, 1018, 198, 1)
}
-- |------------------------------------------------------|
-- | Image Region > Card                                  |
-- |------------------------------------------------------|
Config.rSpeed = Region(1580, 50, 250, 100)
-- |------------------------------------------------------|
-- | Card                                                 |
-- |------------------------------------------------------|
Config.BUSTER_CARD_RATING = 150
Config.ARTS_CARD_RATING = 100
Config.QUICK_CARD_RATING = 80
Config.NP_RATING = 1000
Config.CARD_RATING = 100
Config.CARD_PREFER_RATING = 2.0
Config.CARD_WEAK_RATING = 3.0
Config.CARD_RESIST_RATING = 0.5
-- |------------------------------------------------------|
-- | Common                                               |
-- |------------------------------------------------------|
Config.CARD_POSITION_OFFSET = 385
Config.CARD_NP_POSITION_OFFSET = 350
Config.TARGET_POSITION_OFFSET = 470
Config.SERVANT_POSITION_OFFSET = 475
Config.SKILL_POSITION_OFFSET = 140
Config.SUPPORT_SKILL_POSITION_OFFSET = 116
Config.SWITCH_CURRENT_POSITION_OFFSET = 300
Config.MASTER_SKILL_POSITION_OFFSET = 133
Config.supports = {
    Config.rSupport01,
    Config.rSupport02
}

function Config.init()
    setImmersiveMode(true)
    Settings:setCompareDimension(true, 960)
    Settings:setScriptDimension(true, 1920)
    setImagePath(Config.imagePath)
    Dialog.showPerference()
    Card.reset()
end

return Config
