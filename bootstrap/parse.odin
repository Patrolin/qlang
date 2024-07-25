package bootstrap
import "core:fmt"

/* TODO:
1) find top level names and create dummy nodes
2) find entry proc and start parsing
3) parse all remaining required names
*/

ProcNodeIndex :: distinct u32
ProcNode :: struct {
	name: Token,
}
ExpressionNodeIndex :: distinct u32
ExpressionNode :: struct {
	token: Token,
	left:  ExpressionNodeIndex,
	right: ExpressionNodeIndex,
}
Ast :: struct {
	file:           string,
	tokens:         []Token,
	currentToken:   u32,
	// TODO
	untyped_names:  map[string]Token,
	procs:          [dynamic]ProcNode,
	pending_procs:  [dynamic]ProcNodeIndex,
	required_procs: map[string]ProcNodeIndex,
	expressions:    [dynamic]ExpressionNode,
}
getNextToken :: proc(ast: ^Ast) -> Token {
	return ast.tokens[ast.currentToken]
}
eatToken :: proc(ast: ^Ast) {
	ast.currentToken += 1
}
parseAst :: proc(file: string, tokens: []Token) -> (ast: Ast) {
	ast.file = file
	ast.tokens = tokens
	for {parseTopLevel(&ast)}
	return ast
}
parseExpected :: proc(ast: ^Ast, type: TokenType) -> Token {
	token := getNextToken(ast)
	fmt.assertf(token.type == type, "Invalid token: %v, expected: .%v", token, type)
	eatToken(ast)
	return token
}
parseTopLevel :: proc(ast: ^Ast) {
	// <name> :: proc() {}
	parseExpected(ast, .Name)
	parseExpected(ast, .Colon)
	parseExpected(ast, .Colon)
	parseExpected(ast, .ProcKeyword)
	parseExpected(ast, .LBracket)
	parseExpected(ast, .RBracket)
	parseExpected(ast, .LCurlyBracket)
	for getNextToken(ast).type != .RCurlyBracket {
		parseFunctionLevel(ast)
	}
	eatToken(ast)
}
parseFunctionLevel :: proc(ast: ^Ast) {
	parseExpected(ast, .Name)
	parseExpected(ast, .Colon)
	parseExpected(ast, .Equals)
	parseExpressionLevel(ast)
}
parseExpressionLevel :: proc(ast: ^Ast) {
	token0 := getNextToken(ast)
	#partial switch token0.type {
	case .Name:
		eatToken(ast)
		token1 := getNextToken(ast)
		if token1.type == .LBracket {
			//eatToken(ast)
			// TODO: function
		} else {
			// TODO: variable
		}
	case .String, .Number:
		append(&ast.expressions, ExpressionNode{token0, 0, 0}) // TODO: jblow parsing of binary/unary ops
	case .Plus, .Minus, .Tilde:
	// TODO: unary
	}
}

/*
def isUnary(token: Token) -> bool:
  return (token.type == TokenType.NOT) or (token.type == TokenType.FILE) or (token.type == TokenType.LINE)
def parseLeafOrUnary(tokens: TokenView) -> RuleNode|None:
  next_token = tokens.nextToken()
  if next_token == None:
    return None
  elif next_token.type == TokenType.STRING:
    acc_string_value = ""
    i = 0
    while i < len(next_token.slice):
      if next_token.slice[i] == "\\":
        acc_string_value += next_token.slice[i+1]
        i += 2
      else:
        acc_string_value += next_token.slice[i]
        i += 1
    tokens.eatToken()
    return RuleNode(TokenType.STRING, acc_string_value)
  elif isUnary(next_token):
    node = RuleNode(next_token.type)
    tokens.eatToken()
    node.left = parseLeafOrUnary(tokens)
    return node
  elif next_token.type == TokenType.LBRACKET:
    left_bracket_i = tokens.i
    tokens.eatToken()
    node = parseBinary(tokens, -1)
    next_token = tokens.nextToken()
    if (next_token == None) or (next_token.type != TokenType.RBRACKET): raise ValueError(f"mismatched brackets: {tokens.tokens[left_bracket_i:]}")
    tokens.eatToken()
    return node
  raise ValueError(f"invalid leaf token: {next_token}")
def isBinary(token: Token) -> bool:
  return (token.type == TokenType.AND) or (token.type == TokenType.OR)
def getPrecedence(token: Token) -> int:
  return 0 # make everything be parsed left-to-right
def parseBinaryRightwards(tokens: TokenView, left: RuleNode, minPrecedence: int) -> RuleNode:
  next_token = tokens.nextToken()
  if next_token == None or not isBinary(next_token): return left
  next_precedence = getPrecedence(next_token)
  if next_precedence <= minPrecedence: return left
  tokens.eatToken()
  right = parseBinary(tokens, next_precedence)
  node = RuleNode(next_token.type)
  node.left = left
  node.right = right
  return node
def parseBinary(tokens: TokenView, minPrecedence: int) -> RuleNode|None:
  left = parseLeafOrUnary(tokens)
  while True:
    node = parseBinaryRightwards(tokens, left, minPrecedence)
    if node == left: break
    left = node
  return left
*/
