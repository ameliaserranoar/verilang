module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

start syntax Module = \module: "defmodule" Id name Definition* defs "end";

syntax Definition 
  = usingDef: Using
  | spaceDef: SpaceDef
  | operatorDef: OperatorDef
  | varDef: VarDef
  | ruleDef: RuleDef
  | expressionDef: ExpressionDef
  ;

syntax Using = using: "using" Id name;

syntax SpaceDef = spaceDef: "defspace" Id name SpaceParent? parent "end";

syntax SpaceParent = spaceParent: "\<" Id name;

syntax OperatorDef = operatorDef: "defoperator" Id name ":" {Id "-\>"}+ typeSig AttributeList? attrs "end";

syntax VarDef = varDef: "defvar" {VarDecl ","}+ decls "end";

syntax VarDecl = varDecl: Id name ":" Type tp;

syntax RuleDef = ruleDef: "defrule" Application lhs "-\>" Application rhs "end";

syntax ExpressionDef = expressionDef: "defexpression" LogicalExpression expr AttributeList? attrs "end";

syntax LogicalExpression = OrExpr;

syntax OrExpr 
  = AndExpr
  | left or: OrExpr "or" AndExpr
  ;

syntax AndExpr 
  = EqExpr
  | left and: AndExpr "and" EqExpr
  ;

syntax EqExpr 
  = UnaryExpr
  | left eq: EqExpr "=" UnaryExpr
  | left neq: EqExpr "\<\>" UnaryExpr
  | left lt: EqExpr "\<" UnaryExpr
  | left gt: EqExpr "\>" UnaryExpr
  | left lte: EqExpr "\<=" UnaryExpr
  | left gte: EqExpr "\>=" UnaryExpr
  | left impl: EqExpr "=\>" UnaryExpr
  | left inn: EqExpr "in" UnaryExpr
  ;

syntax UnaryExpr 
  = Atom
  | neg: "neg" Atom
  | forall: "forall" Id var "in" Id domain "." LogicalExpression body
  | exists: "exists" Id var "in" Id domain "." LogicalExpression body
  ;

syntax Atom 
  = atomId: Id
  | atomApp: Application
  | paren: "(" LogicalExpression ")"
  ;

syntax Application = app: "(" Id name LogicalExpression* args ")";

syntax Type = tp: Id name;

syntax AttributeList = attrList: "[" Attribute+ attrs "]";

syntax Attribute = attr: Id name AttributeValue? value;

syntax AttributeValue = attrValue: ":" Id val;

lexical Id = ([a-z][a-z0-9\-]* !>> [a-z0-9\-]) \ Reserved;

lexical IntLiteral = [0-9][0-9]* !>> [0-9];

lexical FloatLiteral = [0-9][0-9]* "." [0-9][0-9]* !>> [0-9];

lexical CharLiteral = "\'" [a-z] "\'";

keyword Reserved = 
  "defmodule" | "using" | "defspace" | "defoperator" | 
  "defexpression" | "defrule" | "defvar" | "end" | 
  "forall" | "exists" | "in" | "defer" | "neg" | 
  "or" | "and";