ServantSkillCommand = {}
ServantSkillCommand.__index = ServantSkillCommand

setmetatable(ServantSkillCommand, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ServantSkillCommand:new(servant, skill, target)
    local self = setmetatable({}, ServantSkillCommand)
    self.servant = servant
    self.skill = skill
    self.target = target
    return self
end

function ServantSkillCommand:getSkill()
    if (self.servant < 1 or self.servant > 3 or self.skill < 1 or self.skill > 3) then
        scriptExit('[ServantSkillCommand] Invalid Skill')
    end
    return Region(40 + Config.SKILL_POSITION_OFFSET * (self.skill - 1) + Config.SERVANT_POSITION_OFFSET * (self.servant - 1), 810, 125, 120)
end

function ServantSkillCommand:getTarget()
    if (self.target < 1 or self.target > 3 or self.target < 1 or self.target > 3) then
        scriptExit('[ServantSkillCommand] Invalid Target')
    end
    return Region(290 + Config.TARGET_POSITION_OFFSET * (self.target - 1), 440, 400, 400)
end

function ServantSkillCommand:execute()
    local result = true
    if (Config.rAttack:exists('btnAttack.png', 15)) then
        local reg = self:getSkill()
        if (reg:exists('usedSkill.png', 0)) then
            scriptExit(string.format('[MasterSkillCommand] Skill Conflict. Servant %i\'s Skill %i has been used.', self.servant, self.skill))
            return false
        end
        click(reg:getCenter())
        if (self.target ~= nil) then
            if (Config.rSkillTarget:exists('target_title.png', 5) ~= nil) then
                click(self:getTarget():getCenter())
            else
                scriptExit('[ServantSkillCommand] Invalid Setting. Target MsgBox Not Found. Maybe it is an AoE skill?')
                return false
            end
        end
        reg:wait('usedSkill.png', 30)
    else
        scriptExit('[ServantSkillCommand] Invalid Position?')
    end
    return result
end
