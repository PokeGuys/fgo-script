local dir = scriptPath()
package.path = package.path .. ';'..dir..'?.lua'
require('app.config')
local api = require('app.api')

setImmersiveMode(true)
Settings:setCompareDimension(true, 960)
Settings:setScriptDimension(true, 1920)

for i, support in pairs(Config.supports) do
    support:highlight()
    print(support:exists('friendMark.png', 0) ~= nil)
end
