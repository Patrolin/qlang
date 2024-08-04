package bootstrap

ExeSections :: struct {
	// TODO: all PE fields
	relocs: ExeRelocSection,
	rdata:  ExeSection,
	data:   ExeSection,
	text:   ExeSection,
}
ExeRelocSection :: struct {
	blocks: [dynamic]ExeRelocBlock,
}
ExeRelocBlock :: struct {
	page_RVA, block_size: u32,
	entries:              [dynamic]ExeReloc,
}
ExeReloc :: struct {
	// 4 bits
	type:   enum u16 {
		NONE  = 0,
		DIR64 = 10,
	},
	offset: u16, // 12 bits
}
ExeSection :: struct {}
