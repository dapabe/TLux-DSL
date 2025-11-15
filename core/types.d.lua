--[[
-----------------------------------
--- Components
]]

--- These properties exists in the Yoga node
---@class DLux.UIStyles
---@field x? number
---@field y? number
---@field w? number
---@field h? number
---@field padding? number | table<number, number> | table<number, number, number, number> # All sides | Vertical/horizontal | All sides independently
---@field margin? number | table<number, number> | table<number, number, number, number> # All sides | Vertical/horizontal | All sides independently
---@field flexGrow? integer
---@field flexDir? "row" | "row-reverse" | "column" | "column-reverse"
---@field flexJustify?  "start" | "center" | "end" | "between" | "around" | "evenly"
---@field flexAlign? "auto" | "stretch" | "start" | "end" | "baseline" | "around" | "between" | "evenly"

--- These properties exists in the component
---@class DLux.UIPropsExtra: DLux.UIStyles
---@field UINode? luyoga.Node # Defined inside the component
---@field debugOutline? boolean # Default `false`

--- Struct of a component
---@class DLux.UIComponent
---@field name string # Name of the node/component
---@field props DLux.UIPropsExtra
---@field children DLux.UIComponent[]
---@field _update? fun(self: self)
---@field _draw? fun(self: self)

--[[
-----------------------------------
--- Routing
]]

---@class DLux.FileRoute
---@field routeNode DLux.ViewPrimitive
---@field enter fun(self: self, next: DLux.FileRoute, ...) # next could be nil in case of being the first route
---@field leave fun(self: self, next: DLux.FileRoute, ...) # Leaving this route and navigation to 'next'
---@field pause fun(self: self, ...)
---@field resume fun(self: self, ...)
---@field keypressed fun(self: self, key: love.keypressed)
---@field update fun(self: self, dt: number)
---@field draw fun(self: self)

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