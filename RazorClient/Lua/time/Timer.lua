local StreamMap = require("common.StreamMap")
local Timer = {}

function Timer:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    instance.lastid = 0
    instance._allTimers = StreamMap:New()
    return instance
end

---@param id any 不能用整数
---@param delay number
---@param task function
function Timer:schedule(id, delay, task, ...)
    local tid, timer = self:_get(id)
    timer.once = true
    timer.remain = delay
    timer.task = task
    timer.debugName = id
    timer.arg1, timer.arg2, timer.arg3, timer.arg4 = ... --- 注意，最多4个
    self._allTimers:Put(tid, timer)
    return tid
end

function Timer:_get(id)
    local timer
    if id then
        timer = self._allTimers:Get(id)
        if timer == nil then
            timer = {}
        end
    else
        id = self.lastid + 1
        self.lastid = id
        timer = {}
    end
    return id, timer
end

function Timer:unschedule(timerid)
    self._allTimers:Remove(timerid)
end

---@see sfweg
---@param id string
---@param delay number
---@param task function
function Timer:scheduleAtFixedRate(id, delay, period, task, ...)
    local tid, timer = self:_get(id)
    timer.debugName = id
    timer.once = false
    timer.remain = delay
    timer.period = period
    timer.task = task
    timer.arg1, timer.arg2, timer.arg3, timer.arg4 = ...
    self._allTimers:Put(tid, timer)
    return tid
end

local function safeTimerEach(id, timer, self, det)
    timer.remain = timer.remain - det
    if timer.remain <= 0 and timer.active then
        if timer.once then
            self._allTimers:Remove(id)
        else
            timer.remain = timer.period + timer.remain
        end
        timer.task(timer.arg1, timer.arg2, timer.arg3, timer.arg4)

    else
        timer.active = true
    end
end

function Timer:update(det)
    self._allTimers:ForEach(safeTimerEach, self, det)
end

function Timer:dump(print)
    print("==== Timer=,")
    self._allTimers:ForEach(function(id, timer)
        print("timer=" .. id .. ",remain=" .. timer.remain)
    end)
end

return Timer
