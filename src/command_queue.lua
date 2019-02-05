local dir = scriptPath()
package.path = package.path .. ';'..dir..'?.lua'
require 'app/config'
local api = require('app.api')

while (true) do

end
