local dir = scriptPath()
package.path = package.path .. ';'..dir..'?.lua'
require 'app/config'

function main()
    -- 從者 (Servant): 貞德 [Archer] (Jeanne d'Arc), 玉藻前 [Caster] (Tamamo), 馮・霍恩海姆・帕拉塞爾斯 (Paracelsus), 孔明 (Waver)
    -- 禮裝 (CE): 萬華鏡 (Kscope), 隨意 (Any)
    -- Master裝備 (Mystic Codes): 迦勒底戰鬥服 (Chaldea Combat Uniform)

    Config.init()

    Game.addCommand(1, NPCommand:new(1))
    Game.addCommand(1, ServantSkillCommand:new(1, 1, nil))
    Game.addCommand(1, ServantSkillCommand:new(1, 3, nil))
    Game.addCommand(1, ServantSkillCommand:new(2, 3, 1))
    Game.addCommand(1, ServantSkillCommand:new(3, 2, nil))
    Game.addCommand(1, ServantSkillCommand:new(3, 3, 1))

    Game.addCommand(2, NPCommand:new(1))
    Game.addCommand(2, SwitchServantCommand:new(2, 1))
    Game.addCommand(2, ServantSkillCommand:new(1, 2, nil))
    Game.addCommand(2, ServantSkillCommand:new(2, 3, nil))

    Game.addCommand(3, NPCommand:new(1))
    Game.addCommand(3, MasterSkillCommand:new(1, nil))
    Game.addCommand(3, ServantSkillCommand:new(2, 1, 1))

    for farmTime = 1, Config.perference.farmTime do
        local retry = 0
        toast(string.format('開始農第 %i 場', farmTime))
        Game.start()
        if (not waitVanish('Loading.png', 120)) then
            print('Connection timeout')
            break
        end
        while (not Game.isEnd()) do
            if (retry > 5) then
                scriptExit('Keep failing')
            end
            if (Config.rAttack:exists('btnAttack.png', 3)) then
                if (Game.execute(Game.checkRound())) then
                    Game.attack()
                else
                    retry = retry + 1
                    wait(2)
                    print('Command Execution Failed. Ready to retry...')
                end
            end
        end
        Game.finish()
        Config.rQuest:wait('QuestInfo.png', 120)
    end
end

main()
