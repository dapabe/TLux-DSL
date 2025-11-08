---@module "tlux.TLux"
---@alias NodeType "Program" | "NumericLiteral" | "Identifier"  | "BinaryExpr" | "UnaryExpr" | "FunctionDeclaration" | "CallExpr"

---@class ExprIdentifier: Expr

---@class ExprNumber: Expr
---@field value number

---@class ExprNil: ExprNumber

---@class Stmt
---@field kind NodeType

---@class StmtProgram: Stmt
---@field kind "Program"
---@field body table<Stmt>

---@class Expr: Stmt

---@class ExprBinary: Expr
---@field left Expr
---@field right Expr
---@field operator string

---@class ExprIdentifier: Expr
---@field kind "Identifier"
---@field symbol string

---@class ExprNumericLiteral: Expr
---@field kind "NumericLiteral"
---@field value number


