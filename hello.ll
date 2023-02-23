; hello world in 2560 B
@.str = private unnamed_addr constant [13 x i8] c"hello world\0A\00"

%Opaque = type opaque
%Handle = type opaque
%DWORD = type i32

;declare i32 @MessageBoxA(%Opaque* %window_handle, i8* %message, i8* %title, i32 %options)
;define i32 @showMessageBox() {
;    %cast1 = getelementptr [13 x i8],[13 x i8]* @.str, i64 0, i64 0
;    %null_ptr = inttoptr i64 0 to %Opaque*
;    call i32 @MessageBoxA(%Opaque* %null_ptr, i8* %cast1, i8* %cast1, i32 64)
;    ret i32 0
;}

; print to stdout
declare i1 @AllocConsole()
declare %Handle* @GetStdHandle(%DWORD %nStdHandle)
declare i1 @WriteConsoleA(%Handle* %hConsoleOutput, i8* %lpBuffer, %DWORD %nNumberOfCharsToWrite, %DWORD* %lpNumberOfCharsWritten, %Opaque* %lpReserved)
declare i1 @FreeConsole()

declare void @Sleep(%DWORD %dwMilliseconds)

define i32 @main() {
    %cast1 = getelementptr [13 x i8],[13 x i8]* @.str, i64 0, i64 0
    call i1 @AllocConsole() ; TODO: https://learn.microsoft.com/en-us/windows/console/createpseudoconsole ?
    %stdout = call %Handle* @GetStdHandle(%DWORD -11)
    %null_ptr_dword = inttoptr i64 0 to %DWORD*
    %null_ptr = inttoptr i64 0 to %Opaque*
    call void @Sleep(%DWORD 1000)
    call i1 @WriteConsoleA(%Handle* %stdout, i8* %cast1, %DWORD 13, %DWORD* %null_ptr_dword, %Opaque* %null_ptr)
    call void @Sleep(%DWORD 1000)
    ;call i1 @FreeConsole()
    ret i32 0
}
