SwitchServantCommand = {}
SwitchServantCommand.__index = SwitchServantCommand

setmetatable(SwitchServantCommand, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function SwitchServantCommand:new(current, target)
    local self = setmetatable({}, SwitchServantCommand)
    self.current = current
    self.target = target
    return self
end

function SwitchServantCommand:getCurrent()
    if (self.current < 1 or self.current > 3) then
        scriptExit('[SwitchServantCommand] Invalid Current Position')
    end
    return Location(215 + Config.SWITCH_CURRENT_POSITION_OFFSET * (self.current - 1), 520)
end

function SwitchServantCommand:getTarget()
    if (self.target < 1 or self.target > 3) then
        scriptExit('[SwitchServantCommand] Invalid Target')
    end
    return Location(1115 + Config.SWITCH_CURRENT_POSITION_OFFSET * (self.target - 1), 520)
end

function SwitchServantCommand:execute()
    -- TODO: Implement a better switch command.
    local cmd = MasterSkillCommand:new(3, nil)
    cmd:execute()
    wait(1)
    click(self:getCurrent())
    wait(0.2)
    click(self:getTarget())
    wait(1)
    click('btnSwitch.png')
    wait(1)
    return true
end
