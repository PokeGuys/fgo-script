NPCommand = {}
NPCommand.__index = NPCommand

setmetatable(NPCommand, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function NPCommand:new(servant)
    local self = setmetatable({}, NPCommand)
    if (servant < 0 or servant > 3) then
        scriptExit('[NPCommand] Invalid Command')
    end
    self.servant = servant
    return self
end

function NPCommand:getServant()
    return Region(26 + Config.SERVANT_POSITION_OFFSET * (self.servant - 1), 560, 450, 520)
end

function NPCommand:execute()
    print('[NPComamnd] Start execute, servant: ', self.servant)
    -- TODO: Fix bug (Sometime cannot recoginze)
    -- Card.NP[self.servant] = self:getServant():exists('servant_NP.png', 0) ~= nil
    Card.NP[self.servant] = true
    return true
end
