MasterSkillCommand = {}
MasterSkillCommand.__index = MasterSkillCommand

setmetatable(MasterSkillCommand, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function MasterSkillCommand:new(skill, target)
    local self = setmetatable({}, MasterSkillCommand)
    self.skill = skill
    self.target = target
    return self
end

function MasterSkillCommand:getSkill()
    if (self.skill < 1 or self.skill > 3) then
        scriptExit('[MasterSkillCommand] Invalid Skill')
    end
    return Region(1292 + Config.MASTER_SKILL_POSITION_OFFSET * (self.skill - 1), 415, 120, 110)
end

function MasterSkillCommand:getTarget()
    if (self.target < 1 or self.target > 3) then
        scriptExit('[MasterSkillCommand] Invalid Target')
    end
    return Region(290 + Config.TARGET_POSITION_OFFSET * (self.target - 1), 440, 400, 400)
end

function MasterSkillCommand:execute()
    local result = true
    if (Config.rAttack:exists('btnAttack.png', 15)) then
        local reg = self:getSkill()
        validateClick(reg, Config.rMasterSkill, nil)
        if (reg:exists('usedSkill.png', 0)) then
            scriptExit(string.format('[MasterSkillCommand] Skill Conflict. Master Skill %i has been used.', self.skill))
            return false
        end
        click(reg:getCenter())
        if (self.target ~= nil) then
            if (Config.rSkillTarget:exists('target_title.png', 3) ~= nil) then
                click(self:getTarget():getCenter())
            else
                scriptExit('[MasterSkillCommand] Invalid Setting. Target MsgBox Not Found. Maybe it is an AoE skill?')
                return false
            end
        end
    else
        scriptExit('[ServantSkillCommand] Invalid Position?')
    end
    return result
end
