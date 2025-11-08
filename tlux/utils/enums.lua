
---@enum TokenType
_G.TokenType = {
    -- Literal types
    ["Number"] = 1,
    ["Nil"] = 2,
    ["Identifier"] = 3,

    -- Keywords
    ["Variable"] = 4,
    ["Function"] = 5,
    ["LuaMatter"] = 6,
    -- Grouping * Operators
    ["Assign"] = 7,
    ["Equals"] = 8,
    ["Component"] = 9,
    ["BinaryOperator"] = 10,
    ["OpenParen"] = 11,
    ["CloseParen"] = 12,
    ["EndOfFile"] = 13
}

_G.Keywords = {
    ["local"] = TokenType["Variable"],
    ["---"] = TokenType["LuaMatter"],
    ["fn"] = TokenType["Function"]
}