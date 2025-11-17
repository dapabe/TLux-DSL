local Yoga = require("luyoga")

local FLEX_DIR_MAP = {
    column = Yoga.Enums.FlexDirection.Column,
    ["column-reverse"] = Yoga.Enums.FlexDirection.ColumnReverse,
    row = Yoga.Enums.FlexDirection.Row,
    ["row-reverse"] = Yoga.Enums.FlexDirection.RowReverse
}

local FLEX_JUSTIFY_MAP = {
    start   = Yoga.Enums.Justify.FlexStart,
    center  = Yoga.Enums.Justify.Center,
    ["end"] = Yoga.Enums.Justify.FlexEnd,
    between = Yoga.Enums.Justify.SpaceBetween,
    around  = Yoga.Enums.Justify.SpaceAround,
    evenly  = Yoga.Enums.Justify.SpaceEvenly
}

local OVERFLOW_MAP = {
    hidden = Yoga.Enums.Overflow.Hidden,
    scroll = Yoga.Enums.Overflow.Scroll,
    visible = Yoga.Enums.Overflow.Visible
}

local ALIGN_MAP = {
    auto = Yoga.Enums.Align.Auto,
    stretch = Yoga.Enums.Align.Stretch,
    start = Yoga.Enums.Align.FlexStart,
    ["end"] = Yoga.Enums.Align.FlexEnd,
    between = Yoga.Enums.Align.SpaceBetween,
    around = Yoga.Enums.Align.SpaceAround,
    evenly = Yoga.Enums.Align.SpaceEvenly,
    baseline = Yoga.Enums.Align.Baseline
}

---@type table<string, fun(s: luyoga.Style, v: any)>
local STYLE_MAP = {
    w = function(s, v) s:setWidth(v) end,
    h = function(s, v) s:setHeight(v) end,
    flexGrow = function(s, v) s:setFlexGrow(v) end,
    flexShrink = function(s, v) s:setFlexShrink(v) end,
    selfAlign = function(s, v) s:setAlignSelf(ALIGN_MAP[v]) end,
    flexJustify = function(s, v) s:setJustifyContent(FLEX_JUSTIFY_MAP[v]) end,
    flexDir = function(s, v) s:setFlexDirection(FLEX_DIR_MAP[v]) end,
    overflow = function(s, v) s:setOverflow(OVERFLOW_MAP[v]) end,
    padding = function(s, v)
        if type(v) == "number" then
            s:setPadding(Yoga.Enums.Edge.All, v)
        elseif #v == 2 then
            s:setPadding(Yoga.Enums.Edge.Horizontal, v[1] or 0)
            s:setPadding(Yoga.Enums.Edge.Vertical, v[2] or 0)
        else
            s:setPadding(Yoga.Enums.Edge.Top, v[1] or 0)
            s:setPadding(Yoga.Enums.Edge.Right, v[2] or 0)
            s:setPadding(Yoga.Enums.Edge.Bottom, v[3] or 0)
            s:setPadding(Yoga.Enums.Edge.Left, v[4] or 0)
        end
    end,
    margin = function(s, v)
        if type(v) == "number" then
            s:setMargin(Yoga.Enums.Edge.All, v)
        elseif #v == 2 then
            s:setMargin(Yoga.Enums.Edge.Horizontal, v[1] or 0)
            s:setMargin(Yoga.Enums.Edge.Vertical, v[2] or 0)
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
local function applyNodeProps(style, props)
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

return applyNodeProps
