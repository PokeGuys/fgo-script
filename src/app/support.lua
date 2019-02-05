local api = require('app.api')

Support = {}

Support.AUTO_SELECT = 1
Support.SPECIFIC_SERVANT = 2
Support.SPECIFIC_CE = 3
Support.BOTH = 4

local function refresh()
    Config.rFriendFunc:waitClick('btnFrdRefresh.png')
    Dialog.clickYesNoDialog(true)
    Config.rFriendFunc:wait('btnFrdRefresh.png', 30)
end

local function isFriend(reg)
    if (not Config.perference.isFriend) then
        return true
    end
    return reg:exists('friendMark.png', 0) ~= nil
end

local function getSupportSkill(support, skill)
    local sup = support:exists('SupportSwipe.png', 0):getTarget()
    return Region(sup:getX() - 79 + Config.SUPPORT_SKILL_POSITION_OFFSET * (skill - 1), sup:getY() + 170, 50, 39)
end

local function matchSkillLevel(reg)
    usePreviousSnap(false)
    if (not Config.perference.enableSkillFilter) then
        return true
    end
    for i = 1, 3 do
        if (Config.perference.supportSkill[i] ~= nil and Config.perference.supportSkill[i] > 0) then
            local fileName = string.format('servant_skill_%i.png', i)
            OCR(getSupportSkill(reg, i), fileName)
            local response = api.fetchServantSkillLevelByOCR(fileName)
            if (response.success) then
                if (response.message.level < Config.perference.supportSkill[i]) then
                    return false
                end
            else
                return false
            end
        end
    end
    return true
end

local function scrollSupport()
    if (Config.rSupport03:exists('SupportSwipe.png', 0.5) ~= nil) then
        setDragDropTiming(500, 500)
        setDragDropStepCount(150)
        setDragDropStepInterval(3)
        dragDrop(Config.rSupport03:exists('SupportSwipe.png', 0), Config.rSupport01:exists('SupportSwipe.png', 0))
        return true
    end
    return false
end

local function selectByCE()
    repeat
        snapshot()
        for i, support in pairs(Config.supports) do
            if (isFriend(support)) then
                Settings:set('MinSimilarity', 0.955)
                local result = support:exists(Config.perference.supportCE, 0)
                if (result ~= nil) then
                    api.log('[selectByCE] CE Score: ' .. result:getScore())
                    if (matchSkillLevel(support)) then
                        Settings:set('MinSimilarity', 0.7)
                        click(result)
                        return true
                    end
                else
                    api.log('[selectByCE] CE Not Found')
                end
                Settings:set('MinSimilarity', 0.7)
            end
        end
        usePreviousSnap(false)
    until (not scrollSupport())
    refresh()
    return selectByCE()
end

local function selectByServant()
    repeat
        snapshot()
        for i, support in pairs(Config.supports) do
            if (isFriend(support)) then
                local result = support:exists(Config.perference.supportServant, 0)
                if (result ~= nil) then
                    api.log('[selectByServant] Servant Score: ' .. result:getScore())
                else
                    api.log('[selectByServant] Servant Not Found')
                end
                if (result ~= nil and matchSkillLevel(support)) then
                    click(result)
                    return true
                end
            end
        end
        usePreviousSnap(false)
    until (not scrollSupport())
    refresh()
    return selectByServant()
end

local function selectBoth()
    repeat
        snapshot()
        for i, support in pairs(Config.supports) do
            if (isFriend(support)) then
                Settings:set('MinSimilarity', 0.955)
                local result = support:exists(Config.perference.supportCE, 0)
                Settings:set('MinSimilarity', 0.7)
                local servant = support:exists(Config.perference.supportServant, 0)
                if (result ~= nil) then
                    api.log('[selectBoth] CE Score: ' .. result:getScore())
                else
                    api.log('[selectBoth] CE Not Found')
                end
                if (servant ~= nil) then
                    api.log('[selectBoth] Servant Score: ' .. support:getLastMatch():getScore())
                else
                    api.log('[selectBoth] Servant Not Found')
                end
                if (result ~= nil and servant ~= nil) then
                    if (matchSkillLevel(support)) then
                        click(servant)
                        return true
                    end
                end
            end
        end
        usePreviousSnap(false)
    until (not scrollSupport())
    refresh()
    return selectBoth()
end

function Support.select()
    if (Config.perference.support == Support.AUTO_SELECT) then
        return Config.rSupport01:waitClick('SupportSwipe.png')
    elseif (Config.perference.support == Support.SPECIFIC_SERVANT) then
        return selectByServant()
    elseif (Config.perference.support == Support.SPECIFIC_CE) then
        return selectByCE()
    elseif (Config.perference.support == Support.BOTH) then
        return selectBoth()
    else
        scriptExit('[Support.select] Invalid Option')
    end
end
