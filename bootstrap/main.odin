package bootstrap
import "core:fmt"

main :: proc() {
	str := `
		main :: proc() {
			stdout := GetStdHandle(-11)
			WriteFile(stdOut, "Hello world!", 12, 0, 0);
		}`
	ast := parseAst(FileView{path = "<inline>", str = str, i = 0})
	fmt.printfln("ast: %v", ast)
	// TODO: free tokens after parseAst()?
}
