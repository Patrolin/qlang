package bootstrap

AsmSections :: struct {
	relocs: AsmRelocSection,
	rdata:  AsmSection,
	data:   AsmSection,
	text:   AsmSection,
}
AsmRelocSection :: struct {
	entries: [dynamic]ExeReloc,
}
AsmSection :: struct {}
