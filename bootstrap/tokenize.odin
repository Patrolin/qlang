package bootstrap
import "core:fmt"

TokenType :: enum u32 {
	Invalid,
	Number,
	String,
	ProcKeyword,
	Name,
	Colon,
	Equals,
	Plus,
	Minus,
	Star,
	Slash,
	Caret,
	Ampersand,
	Pipe,
	Tilde,
	Comma,
	LBracket,
	RBracket,
	LSquareBracket,
	RSquareBracket,
	LCurlyBracket,
	RCurlyBracket,
}
Token :: struct {
	start: u32,
	type:  TokenType,
}

isNumberToken :: proc(char: u8) -> bool {
	return (char >= '0' && char <= '9') || (char >= 'a' && char <= 'f') || char == 'x'
}
isNameToken :: proc(char: u8) -> bool {
	return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z')
}
// TODO: refactor to tokenizeOnce and call inside getNextToken()?
tokenize :: proc(file: string) -> [dynamic]Token {
	tokens := [dynamic]Token{}
	i: u32 = 0
	for i < u32(len(file)) { 	// TODO: iterate over runes?
		start_char := file[i]
		switch start_char {
		// number, string
		case '0' ..= '9':
			append(&tokens, Token{start = i, type = .Number})
			for i += 1; i < u32(len(file)) && isNumberToken(file[i]); i += 1 {}
			continue
		case '"':
			append(&tokens, Token{start = i, type = .String})
			for i += 1; i < u32(len(file)) && file[i] != '"'; i += (file[i] == '\\' ? 2 : 1) {}
			continue
		// keywords, name
		case 'a' ..= 'z', 'A' ..= 'Z':
			start_i := i
			for i += 1; i < u32(len(file)) && isNameToken(file[i]); i += 1 {}
			switch file[start_i:i] {
			case "proc":
				append(&tokens, Token{start = i, type = .ProcKeyword})
			case:
				append(&tokens, Token{start = i, type = .Name})
			}
			continue
		// symbols
		case ':':
			append(&tokens, Token{start = i, type = .Colon})
		case '=':
			append(&tokens, Token{start = i, type = .Equals})
		case '+':
			append(&tokens, Token{start = i, type = .Plus})
		case '-':
			append(&tokens, Token{start = i, type = .Minus})
		case '*':
			append(&tokens, Token{start = i, type = .Star})
		case '/':
			append(&tokens, Token{start = i, type = .Slash})
		case '^':
			append(&tokens, Token{start = i, type = .Caret})
		case '&':
			append(&tokens, Token{start = i, type = .Ampersand})
		case '|':
			append(&tokens, Token{start = i, type = .Pipe})
		case '~':
			append(&tokens, Token{start = i, type = .Tilde})
		case ',':
			append(&tokens, Token{start = i, type = .Comma})
		// brackets
		case '(':
			append(&tokens, Token{start = i, type = .LBracket})
		case ')':
			append(&tokens, Token{start = i, type = .RBracket})
		case '[':
			append(&tokens, Token{start = i, type = .LSquareBracket})
		case ']':
			append(&tokens, Token{start = i, type = .RSquareBracket})
		case '{':
			append(&tokens, Token{start = i, type = .LCurlyBracket})
		case '}':
			append(&tokens, Token{start = i, type = .RCurlyBracket})
		case ' ', '\t', '\r', '\n':
		// noop
		case:
			fmt.assertf(false, "Unknown character: %v, \"%v\"", i, start_char, rune(start_char))
		}
		i += 1
	}
	return tokens
}
