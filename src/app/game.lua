local api = require('app.api')

Game = {}

Game.isCaptured = false
Game.history = {}
Game.commands = {}
Game.quest = nil
Game.round = 0

local function getRemainAP()
    click(Config.rAPMsg:getLastMatch())
    APMsg = Config.rAPMsg:exists('CurrenAPMsg.png', 0)
    OCR(Region(APMsg:getX() + 316, APMsg:getY(), 300, 66), 'playerAP.png')
    local response = api.fetchPlayerAPbyOCR('playerAP.png')
    Config.rAPMsg:waitClick('btnCancel.png', 2)
    if (response.success) then
        return Game.quest.AP == -1 and 10 or (Game.quest.AP - response.message.AP)
    else
        return 10
    end
end

local function refillAP()
    local staminaItem = Config.perference.staminaItem
    if (Config.rAPMsg:exists('isAPPage.png', 2)) then
        if (staminaItem == Config.AP_AUTO_RECOVERY) then
            local AP = 5
            if (Game.quest ~= nil and Game.quest.id > 0) then
                if (not Config.rAPMsg:exists('appleGolden.png', 0) and not Config.rAPMsg:exists('appleSilver.png', 0) and not Config.rAPMsg:exists('SQ.png', 0)) then
                    swipe('appleSilver.png', 'appleGolden.png')
                    if (Config.rAPMsg:exists('appleBronzen.png', 2)) then
                        AP = getRemainAP()
                    end
                else
                    AP = getRemainAP()
                end
            end
            click(Config.AP[staminaItem])
            toast(string.format('Insufficient AP. Wait %i minutes', AP * 5))
            return AP * (5 * 60)
        elseif (staminaItem == Config.AP_USE_COPPER_APPLE) then
            swipe('appleSilver.png', 'appleGolden.png')
        end
        click(Config.AP[staminaItem])
        waitClick('btnConfirm.png', 3)
    end
    return 0
end

function Game.addCommand(round, command)
    if (Game.commands[round] == nil) then
        Game.commands[round] = {}
    end
    table.insert(Game.commands[round], command)
end

function Game.execute(round)
    local result = true
    if (Game.commands[round] ~= nil) then
        for i = 1, table.getn(Game.commands[round]) do
            local command = table.remove(Game.commands[round], 1)
            if (Game.history[round] == nil) then
                Game.history[round] = {}
            end
            table.insert(Game.history[round], command)
            result = result and command:execute()
        end
    end
    return result
end

function Game.checkRound()
    snapshot()
    setImagePath(Config.runtimePath)
    if (Game.round == 0 or not Game.isCaptured or not fileExists(Config.runtimePath .. 'round.png') or Config.rRound:exists(Pattern('round.png'):similar(0.9)) == nil) then
        Game.round = Game.round + 1
        Config.rRound:save('round.png')
        Game.isCaptured = true
    end
    setImagePath(Config.imagePath)
    usePreviousSnap(false)
    print('Round '.. Game.round)

    return Game.round
end

function Game.attack()
    for i = 1, 3 do
        local info = Card.info[i]
        if (info.enabled) then
            local fileName = 'servant_np_'..i..'.png'
            OCR(Config.rServantNP[i], fileName)
            local response = api.fetchNPByOCR(fileName)
            if (response.success) then
                local NP = response.message.NP
                if (NP < 100) then
                    print(string.format('[Servant %i] Not able to unleash, NP: %i', i, NP))
                    Card.NP[i] = false
                end
            end
        end
    end
    Config.rAttack:waitClick('btnAttack.png', 30)
    while (not Config.rSpeed:exists('battle_speed.png', 5)) do
        Config.rAttack:waitClick('btnAttack.png', 30)
    end
    Card.update()
    Card.select()
end

function Game.start()
    if (Config.rQuest:exists('QuestInfo.png', 0) ~= nil) then
        local questInfo = Config.rQuest:getLastMatch()
        local rQuestName = Region(questInfo:getX() - 630, questInfo:getY() - 125, 450, 40)
        OCR(rQuestName, 'quest_name.png')
        local response = api.fetchQuestInfoByOCR('quest_name.png')
        if (response.success) then
            Game.quest = response.message.quest
        else
            scriptExit(string.format('[Game.start] Fetch Quest API failed. (%s)', response.message))
        end
        validateClick(rQuestName, rQuestName:getCenter(), nil)
        if (Config.rAPMsg:exists('isAPPage.png', 1)) then
            local AP_interval = refillAP()
            wait(AP_interval)
            if (AP_interval > 0) then
                validateClick(rQuestName, rQuestName:getCenter(), nil)
            end
        end
        Config.rFriendFunc:exists('btnFrdRefresh.png', 5)
    end
    Config.rFriendFunc:wait('btnFrdRefresh.png')
    Support.select()
    Config.rQuestStart:waitClick('btnStartQuest.png')
    Game.isCaptured = false
    Game.round = 0
    Card.NP = { false, false, false }
    api.postStartQuest(Game.quest.id)
    return true
end

function Game.finish()
    if (Config.rBondMsg:exists('bond_reward_title.png', 0)) then
        repeat
            doubleClick(Config.rBondMsg:getLastMatch())
            wait(0.5)
        until (Config.rEXPMsg:exists('exp_reward_title.png', 0))
    end
    repeat
        doubleClick(Config.rEXPMsg:getLastMatch())
        wait(0.5)
    until (Config.rDropMsg:exists('drop_reward_button.png', 0))
    while (Config.rDropMsg:exists('drop_reward_button.png', 3)) do
        click(Config.rDropMsg:getLastMatch())
    end
    -- TODO: Reward Page
    if (Config.rFrdRequest:exists('btnFrdNo.png')) then
        click(Config.rFrdRequest:getLastMatch())
    end
    Game.commands = table.clone(Game.history)
    Game.history = {}
    api.postEndQuest(Game.quest.id)
end

function Game.isEnd()
    return Config.rBondMsg:exists('bond_reward_title.png', 0) or Config.rEXPMsg:exists('exp_reward_title.png', 0) or Config.rDropMsg:exists('drop_reward_button.png', 0)
end
