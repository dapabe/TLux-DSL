--[[
-----------------------------------
--- Components
]]
---@alias DLux.SizeFactor {width: number, height: number} | {flexGrow: integer}

---@class DLux.UILayoutPrimitive
---@field x? number
---@field y? number
---@field padding? number | table<number, number> | table<number, number, number, number> # All sides | Vertical/horizontal | All sides independently
---@field size? DLux.SizeFactor

---@class DLux.UINode: DLux.UILayoutPrimitive
---@field type string # Name of the node/component
---@field color? table<number, number, number, number>
---@field flexDirection? "row" | "column"
---@field flexJustify?  "start" | "center" | "end" | "between" | "around"
---@field flexAlign? "start" | "center" | "end" | "stretch"
---@field _computed? {x: number, y: number, width: number, height: number}
---@field children? DLux.UINode[]

---@class DLux.UIComponent
---@field props DLux.UINode
---@field children DLux.UIComponent[]
---@field _update? fun(self: self)
---@field _draw? fun(self: self)

--[[
-----------------------------------
--- Compiler
]]

---@alias DLux.TokenType
--- | "Program"
--- | "NumberLiteral"
--- | "StringLiteral"
--- | "BooleanLiteral"
--- | "Identifier"

---@class DLux.Statement
---@field kind DLux.TokenType

---@class StmtProgram: DLux.Statement
---@field kind "Program"
---@field body DLux.Statement[]

---@class DLux.Expression: DLux.Statement

---@class DLux.ExprBinary: DLux.Expression
---@field left DLux.Expression
---@field right DLux.Expression
---@field operator string

---@class DLux.ExprNumberLiteral: DLux.Expression
---@field kind "NumberLiteral"
---@field value number

---@class DLux.ExprStringLiteral: DLux.Expression
---@field kind "StringLiteral"
---@field value string