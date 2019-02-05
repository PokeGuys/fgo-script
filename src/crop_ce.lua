local dir = scriptPath()
package.path = package.path .. ';'..dir..'?.lua'
require('app.config')
local api = require('app.api')

setImmersiveMode(true)
setImagePath(Config.imagePath)
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 1920)

toast('請先到好友列表找出指定禮裝，十秒後將進行判定。')
wait(10)
local sup = Config.rSupport01:wait('SupportSwipe.png', 90)
local rSupportCE = Region(sup:getX() - 1169, sup:getY() + 170, 225, 60)
rSupportCE:save('custom-ce.png')

toast('CE Saved')
