package bootstrap
import "core:fmt"

main :: proc() {
	file := `
		main :: proc() {
			stdout := GetStdHandle(-11)
			WriteFile(stdOut, "Hello world!", 12, 0, 0);
		}`
	tokens := tokenize(file)
	fmt.printfln("tokens: %v", tokens)
	// TODO: free file after tokenize()

	ast := parseAst(file, tokens[:])
	fmt.printfln("ast: %v", ast)
	// TODO: free tokens after parseAst()
}
