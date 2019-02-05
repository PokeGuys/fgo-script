Dialog = {}

function Dialog.clickYesNoDialog(state)
    local result = true
    usePreviousSnap(false)
    if (Config.rDialog:exists(state and 'btnYes.png' or 'btnNo.png', 1)) then
        print('btnYesNo Found')
    elseif (Config.rDialog:exists('btnClose.png', 1)) then
        print('btnClose Found')
        result = false
    end
    click(Config.rDialog:getLastMatch())
    return result
end

function Dialog.showSupport()
    servant, ce, skill1, skill2, skill3, enableSkillFilter, forceUpdateCE = 0, 0, 0, 0, 0, false, false
    dialogInit()
    addCheckBox('enableSkillFilter', '設定Support技能等級?', false)
    newRow()
    addSpinnerIndex('skill1', Config.SKILL_LEVEL_LIST, 1)
    addSpinnerIndex('skill2', Config.SKILL_LEVEL_LIST, 1)
    addSpinnerIndex('skill3', Config.SKILL_LEVEL_LIST, 1)
    if (Config.perference.support == Support.SPECIFIC_SERVANT or Config.perference.support == Support.BOTH) then
        newRow()
        addTextView('使用什麼英靈作Support?')
        newRow()
        addSpinnerIndex('servant', {
            '孔明',
            '梅林',
            '術師匠',
        }, 1)
    end
    if (Config.perference.support == Support.SPECIFIC_CE or Config.perference.support == Support.BOTH) then
        newRow()
        addTextView('使用什麼禮裝?')
        newRow()
        addSpinnerIndex('ce', {
            '野餐 (絆 10%)',
            '文西 (QP 10%)',
            '學妹 (EXP 10%)',
            '所長 (禮裝 10%)',
            '新所長 (EXP 15%)',
            '新學妹 (絆 15%)',
            '寶石翁 (NP 100%)',
            '自定義禮裝'
        }, 1)
        newRow()
        addCheckBox('forceUpdateCE', '是否重新截取自定義禮裝圖片?', false)
    end
    dialogShow('腳本設定')
    if (Config.perference.support == Support.SPECIFIC_SERVANT or Config.perference.support == Support.BOTH) then
        Config.perference.supportServant = Config.SUPPORT_SERVERT_LIST[servant]
    end
    if (Config.perference.support == Support.SPECIFIC_CE or Config.perference.support == Support.BOTH) then
        if (forceUpdateCE and ce == 7) then
            toast('請先到好友列表找出指定禮裝，十秒後將進行判定。')
            wait(10)
            local sup = Config.rSupport01:wait('SupportSwipe.png', 90)
            local rSupportCE = Region(sup:getX() - 1169, sup:getY() + 170, 225, 60)
            rSupportCE:save('custom.png')
            click(Config.rBack:getCenter())
            Config.rQuest:wait('QuestInfo.png', 30)
        end
        Config.perference.supportCE = Config.SUPPORT_CE_LIST[ce]
    end
    Config.perference.supportSkill = {skill1, skill2, skill3}
    Config.perference.enableSkillFilter = enableSkillFilter
    if (enableSkillFilter) then
        for i, s in pairs(Config.perference.supportSkill) do
            if (s > 10) then
                Config.perference.supportSkill[i] = 10
            elseif (s < 0) then
                Config.perference.supportSkill[i] = 0
            end
        end
    end
end

function Dialog.showPerference()
    farmTime, staminaItem, attackType, attackType, isFriend = 0, 0, 0, 0, false
    dialogInit()
    addTextView('農多少場?')
    addEditNumber('farmTime', 1)
    newRow()
    addTextView('使用什麼道具回覆體力?')
    newRow()
    addSpinnerIndex('staminaItem', {
        '自然回體',
        '金蘋果',
        '銀蘋果',
        '銅蘋果',
        '聖晶石'
    }, 1)
    newRow()
    addTextView('主要攻擊卡片?')
    newRow()
    addSpinnerIndex('attackType', {
        '預設 (Buster)',
        'Buster (B).',
        'Arts (A)',
        'Quick (Q)',
        'Non-Chain'
    }, 1)
    newRow()
    addTextView('使用Support類型?')
    newRow()
    addSpinnerIndex('support', {
        '攻擊力最高',
        '指定英靈',
        '指定禮裝',
        '指定英靈及禮裝'
    }, 1)
    newRow()
    addCheckBox('isFriend', '僅使用好友Support?', true)
    dialogShow('腳本設定')
    Config.perference.farmTime = farmTime
    Config.perference.staminaItem = staminaItem
    Config.perference.attackType = Config.perferredType[attackType]
    Config.perference.support = support
    Config.perference.isFriend = isFriend
    if (support > 1) then
        Dialog.showSupport()
    end
end
