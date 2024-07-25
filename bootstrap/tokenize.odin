package bootstrap
import "core:fmt"

Token :: struct {
	start: u32,
	type:  enum u32 {
		Number,
		String,
		Plus,
		Minus,
		Star,
		Slash,
		Caret,
		LBracket,
		RBracket,
		LSquareBracket,
		RSquareBracket,
		LCurlyBracket,
		RCurlyBracket,
	},
}

isNumberToken :: proc(char: u8) -> bool {
	return (char >= '0' && char <= '9') || (char >= 'a' && char <= 'f') || char == 'x'
}
tokenize :: proc(str: string) -> [dynamic]Token {
	tokens := [dynamic]Token{}
	i: u32 = 0
	for i < u32(len(str)) { 	// TODO: iterate over runes?
		start_char := str[i]
		switch start_char {
		case '0' ..= '9':
			append(&tokens, Token{start = i, type = .Number})
			for i += 1; i < u32(len(str)) && isNumberToken(str[i]); i += 1 {}
			continue
		case '"':
			append(&tokens, Token{start = i, type = .String})
			for i += 1; i < u32(len(str)) && str[i] != '"'; i += (str[i] == '\\' ? 2 : 1) {}
			continue
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
			fmt.assertf(false, "Unknown character: %v, %v", i, rune(start_char))
		}
		i += 1
	}
	return tokens
}

main :: proc() {
	tokens := tokenize("123 + 456")
	fmt.printfln("tokens: %v", tokens)
}
