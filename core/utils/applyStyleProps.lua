local Yoga = require("luyoga")

---@type table<string, fun(s: luyoga.Style, v: any)>
local STYLE_MAP = {
    w = function (s, v) s:setWidth(v) end,
    h = function (s, v) s:setHeight(v) end,
    flexGrow = function(s, v) s:setFlexGrow(v) end,
    flexShrink = function(s, v) s:setFlexShrink(v) end,
    selfAlign = function(s, v) s:setAlignSelf(v) end,
    flexJustify = function(s, v) s:setJustifyContent(v) end,
    flexDir = function (s, v) s:setFlexDirection(v) end,
    overflow = function (s, v) s:setOverflow(v) end,
    padding = function (s, v)
        if type(v) == "number" then
            s:setPadding(Yoga.Enums.Edge.All, v)
        else
            s:setPadding(Yoga.Enums.Edge.Top, v[1] or 0)
            s:setPadding(Yoga.Enums.Edge.Right, v[2] or 0)
            s:setPadding(Yoga.Enums.Edge.Bottom, v[3] or 0)
            s:setPadding(Yoga.Enums.Edge.Left, v[4] or 0)
        end
    end,
    margin = function (s, v)
        if type(v) == "number" then
            s:setMargin(Yoga.Enums.Edge.All, v)
        else
            s:setMargin(Yoga.Enums.Edge.Top, v[1] or 0)
            s:setMargin(Yoga.Enums.Edge.Right, v[2] or 0)
            s:setMargin(Yoga.Enums.Edge.Bottom, v[3] or 0)
            s:setMargin(Yoga.Enums.Edge.Left, v[4] or 0)
        end
    end
}

---@generic ComponentProps
---@param style luyoga.Style
---@param props ComponentProps
local function applyStyleProps(style, props)
    for k, v in pairs(props) do
        local setter = STYLE_MAP[k]
        if setter then
            setter(style, v)
        else
            if k == "position" and type(v) == "table" then
                for edge, val in ipairs(v) do
                    style:setPosition(Yoga.Enums[edge], val)
                end
            end
        end
    end
end

return applyStyleProps