local dir = scriptPath()
package.path = package.path .. ';'..dir..'?.lua'
require 'app.config'

function main()
    setImmersiveMode(true)
    Settings:setCompareDimension(true, 960)
    Settings:setScriptDimension(true, 1920)
    setImagePath(scriptPath() .. '/2018christmas/')

    while (true) do
        local resetRegion = Region(1420, 330, 640, 80)
        while (not resetRegion:exists('btnReset.png', 0)) do
            continueClick(530, 645, 170, 55, math.random(50, 100))
        end
        click(resetRegion:getLastMatch())
        Config.rDialog:existsClick('btnExecute.png', 1)
        wait(0.5)
        Config.rDialog:existsClick('btnClose.png', 1)
    end
end

main()
