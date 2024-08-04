package bootstrap
import "core:fmt"

TokenType :: enum u32 {
	// N-grams
	Number,
	String,
	Name,
	SingleLineComment,
	Slash,
	// 2-grams
	ColonColon,
	ColonEquals,
	Colon,
	EqualsEquals,
	Equals,
	LessThanOrEqual,
	LessThan,
	GreaterThanOrEqual,
	GreaterThan,
	AmpersandAmpersand,
	Ampersand,
	PipePipe,
	Pipe,
	// 1-grams
	Plus,
	Minus,
	Star,
	Caret,
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
	end:   u32,
	type:  TokenType,
}
FileView :: struct {
	path: string,
	str:  string,
	i:    u32,
}

isNumberToken :: proc(char: u8) -> bool {
	return(
		(char >= '0' && char <= '9') ||
		(char >= 'a' && char <= 'z') ||
		(char >= 'A' && char <= 'Z') ||
		char == '.' ||
		char == '_' \
	)
}
isNameToken :: proc(char: u8) -> bool {
	return (char >= 'a' && char <= 'z') || (char >= 'A' && char <= 'Z') || char == '_'
}
eatToken :: proc(view: ^FileView, token: Token) {
	view.i = token.end
}
getNextToken :: proc(view: ^FileView) -> (token: Token) {
	token = peekNextToken(view)
	eatToken(view, token)
	return
}
peekNextToken :: proc(view: ^FileView) -> (token: Token) {
	i := view.i
	str := view.str
	for ; i < u32(len(str)) &&
	    (str[i] == ' ' || str[i] == '\t' || str[i] == '\n' || str[i] == '\r');
	    i += 1 {
	}
	token.start = i
	switch str[i] {
	// N-grams
	case '0' ..= '9':
		for i += 1; i < u32(len(str)) && isNumberToken(str[i]); i += 1 {}
		token.end = i
		token.type = .Number
		return
	case '"':
		for i += 1; i < u32(len(str)) && str[i] != '"'; i += (str[i] == '\\' ? 2 : 1) {}
		token.end = i
		token.type = .String
		return
	case 'a' ..= 'z', 'A' ..= 'Z':
		for i += 1; i < u32(len(str)) && isNameToken(str[i]); i += 1 {}
		token.end = i
		token.type = .Name
		return
	case '/':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		switch next_char {
		case '/':
			i += 1
			token.type = .SingleLineComment
			for ; i < u32(len(str)) && str[i] != '\n' && str[i] != '\r'; i += 1 {}
			token.end = i
			return
		// TODO: multiline comment
		case:
			token.type = .Slash
		}
	// 2-grams
	case ':':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		switch next_char {
		case ':':
			i += 1
			token.type = .ColonColon
		case '=':
			i += 1
			token.type = .ColonEquals
		case:
			token.type = .Colon
		}
	case '=':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		if next_char == '=' {
			i += 1
			token.type = .EqualsEquals
		} else {
			token.type = .Equals
		}
	case '<':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		if next_char == '=' {
			i += 1
			token.type = .LessThanOrEqual
		} else {
			token.type = .LessThan
		}
	case '>':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		if next_char == '=' {
			i += 1
			token.type = .GreaterThanOrEqual
		} else {
			token.type = .GreaterThan
		}
	case '&':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		if next_char == '&' {
			i += 1
			token.type = .AmpersandAmpersand
		} else {
			token.type = .Ampersand
		}
	case '|':
		next_char := i + 1 < u32(len(str)) ? str[i + 1] : 0
		if next_char == '&' {
			i += 1
			token.type = .PipePipe
		} else {
			token.type = .Pipe
		}
	// 1-grams
	case '+':
		token.type = .Plus
	case '-':
		token.type = .Minus
	case '*':
		token.type = .Star
	case '^':
		token.type = .Caret
	case '~':
		token.type = .Tilde
	case ',':
		token.type = .Comma
	// brackets
	case '(':
		token.type = .LBracket
	case ')':
		token.type = .RBracket
	case '[':
		token.type = .LSquareBracket
	case ']':
		token.type = .RSquareBracket
	case '{':
		token.type = .LCurlyBracket
	case '}':
		token.type = .RCurlyBracket
	// noop
	case:
		fmt.assertf(false, "Unknown character: %v, \"%v\"", i, str[i], rune(str[i]))
	}
	i += 1
	token.end = i
	return
}
