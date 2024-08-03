package bootstrap
/*
main :: proc() {
  HANDLE stdOut = GetStdHandle(STD_OUTPUT_HANDLE);
  WriteFile(stdOut, str, 12, 0, 0);
}

[
	LoadConstIns{.cstring, "Hello world!"} // loaded from .rdata
	LoadConstIns{.s32, -11} // may or may not be inlined
	CallIns{procs.GetStdHandle, {1}}
	LoadConstIns{.s32, 12}
	LoadConstIns{.s32, 0}
	CallIns{procs.WriteFile, {2, 0, 3, 4, 4}}
	RetIns{{}} // TODO: schedule in time-reverse order
]
*/
InstructionDataType :: enum u32 {
	cstring,
	u8,
	u16,
	u32,
	u64,
	s8,
	s16,
	s32,
	s64,
	f32,
	f64,
}
ProcedureId :: distinct u32
ExtendedBasicBlockId :: distinct u32
InstructionId :: distinct u32

// proc utils
LoadConstIns :: struct {
	type: InstructionDataType,
	data: u64,
}
CallIns :: struct {
	args:   []InstructionId,
	procId: ProcedureId,
}
RetIns :: struct {
	args: []InstructionId,
}
JmpIns :: struct {
	to: ExtendedBasicBlockId,
}
// memory
LoadIns :: struct {
	type: InstructionDataType,
}
StoreIns :: struct {} // TODO
// data
OverflowType :: enum u32 {
	Wrap,
	Except,
	Saturate,
	Widen,
}
AddIntIns :: struct {
	overflowType: OverflowType,
}
SubIntIns :: struct {
	overflowType: OverflowType,
}
MulUnsignedIntIns :: struct {
	overflowType: OverflowType,
}
MulSignedIntIns :: struct {
	overflowType: OverflowType,
}
DivUnsignedIntIns :: struct {
	overflowType: OverflowType,
}
DivSignedIntIns :: struct {
	overflowType: OverflowType,
}
Instruction :: union {
	LoadConstIns,
	LoadIns,
	StoreIns,
	CallIns,
	RetIns,
	JmpIns,
	AddIntIns,
	SubIntIns,
	MulUnsignedIntIns,
	MulSignedIntIns,
	DivUnsignedIntIns,
	DivSignedIntIns,
}
// NOTE: enter at top, leave anywhere
ExtendedBasicBlock :: struct {
	instructions: [dynamic]Instruction,
	refCount:     u32,
}
ProcedureBlock :: struct {
	basicBlocks: map[ExtendedBasicBlockId]ExtendedBasicBlock,
	start:       ExtendedBasicBlockId,
}
