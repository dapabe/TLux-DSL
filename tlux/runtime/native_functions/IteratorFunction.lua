
---@class IteratorFunction
local IteratorFunction = {}
IteratorFunction.__index = IteratorFunction

---@protected
IteratorFunction.initialState = nil
---@protected
IteratorFunction.prevState = nil
---@protected
IteratorFunction.currentState = nil


---@generic State
---@param state State
---@param callback fun(prev: State, current: State): State
---@return State, function, State, State
function IteratorFunction.create(state, callback)
    local instance = setmetatable({}, IteratorFunction)
    instance.initialState = state
    instance.prevState = instance.initialState
    instance.currentState = instance.prevState

    local function update()
        instance.prevState = instance.currentState
        instance.currentState = callback(instance.currentState, instance.prevState)
    end

    return instance.currentState, update, instance.prevState, instance.initialState
end


return IteratorFunction