package bootstrap

ProcedureId :: distinct int // TODO
ExtendedBasicBlockId :: distinct int

StackAllocInstruction :: struct {
	stackSize: int,
}
RetInstruction :: struct {
	stackSize: int,
}
JmpInstruction :: struct {
	to: ExtendedBasicBlockId,
}
CallInstruction :: struct {
	procId: ProcedureId,
}
AddIntInstruction :: struct {}
SubIntInstruction :: struct {}
MulUnsignedIntInstruction :: struct {}
MulSignedIntInstruction :: struct {}
DivUnsignedIntInstruction :: struct {}
DivSignedIntInstruction :: struct {}
Instruction :: union {
	StackAllocInstruction,
	RetInstruction,
	JmpInstruction,
	CallInstruction,
	AddIntInstruction,
	SubIntInstruction,
	MulUnsignedIntInstruction,
	MulSignedIntInstruction,
	DivUnsignedIntInstruction,
	DivSignedIntInstruction,
}
// NOTE: enter at top, leave anywhere
ExtendedBasicBlock :: struct {
	instructions: [dynamic]Instruction,
}
ProcedureBlock :: struct {
	blocks: map[ExtendedBasicBlockId]ExtendedBasicBlock,
}
