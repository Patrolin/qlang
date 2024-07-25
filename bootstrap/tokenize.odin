package bootstrap
import "core:fmt"

Token :: struct {
	start: u32,
	type:  enum u32 {
		Number,
		Name,
		String,
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
	},
}

isNumberToken :: proc(char: u8) -> bool {
	return (char >= '0' && char <= '9') || (char >= 'a' && char <= 'f') || char == 'x'
}
isNameToken :: proc(char: u8) -> bool {
	return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z')
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
		case 'a' ..= 'z', 'A' ..= 'Z':
			append(&tokens, Token{start = i, type = .Name})
			for i += 1; i < u32(len(str)) && isNameToken(str[i]); i += 1 {}
			continue
		case '"':
			append(&tokens, Token{start = i, type = .String})
			for i += 1; i < u32(len(str)) && str[i] != '"'; i += (str[i] == '\\' ? 2 : 1) {}
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

main :: proc() {
	tokens := tokenize(
		`
		main :: proc() {
			stdout := GetStdHandle(-11)
			WriteFile(stdOut, "Hello world!", 12, 0, 0);
		}`,
	)
	fmt.printfln("tokens: %v", tokens)
}
