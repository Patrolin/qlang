; clang hello.ll -o hello.exe -nostdinc -nostdlib -nostdlib++ -no-integrated-cpp -z /subsystem:windows -z /entry:main -z Kernel32.lib -z User32.lib
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

%INPUT_RECORD = type { i16, [9 x i16] }

; print to stdout
declare i1 @AllocConsole()
declare %Handle* @GetStdHandle(%DWORD %nStdHandle)
declare i1 @WriteConsoleA(%Handle* %hConsoleOutput, i8* %lpBuffer, %DWORD %nNumberOfCharsToWrite, %DWORD* %lpNumberOfCharsWritten, %Opaque* %lpReserved)

; meh
declare i1 @FreeConsole()
declare i1 @AttachConsole(%DWORD %dwProcessId)
declare i1 @SetConsoleMode(%Handle* %hConsoleHandle, %DWORD %dwMode)
declare i1 @PeekConsoleInputA(%Handle* %hConsoleInput, %INPUT_RECORD* %lpBuffer, %DWORD %nLength, %DWORD* %lpNumberOfEventsRead)
declare void @Sleep(%DWORD %dwMilliseconds)

define i32 @main() {
    %cast1 = getelementptr [13 x i8],[13 x i8]* @.str, i64 0, i64 0
    call i1 @AllocConsole()
    ;call i1 @AttachConsole(%DWORD -1)
    %stdin = call %Handle* @GetStdHandle(%DWORD -10)
    ;call i1 @SetConsoleMode(%Handle* %stdin, %DWORD 0)
    %stdout = call %Handle* @GetStdHandle(%DWORD -11)
    %stderr = call %Handle* @GetStdHandle(%DWORD -12)
    call i1 @WriteConsoleA(%Handle* %stdout, i8* %cast1, %DWORD 12, %DWORD* null, %Opaque* null)
    call void @Sleep(%DWORD 1000)
    call i1 @WriteConsoleA(%Handle* %stdout, i8* %cast1, %DWORD 12, %DWORD* null, %Opaque* null)
    call void @Sleep(%DWORD 1000)
    call i1 @WriteConsoleA(%Handle* %stdout, i8* %cast1, %DWORD 12, %DWORD* null, %Opaque* null)
    call void @Sleep(%DWORD 1000)
    ;call i1 @FreeConsole()
    ret i32 0
}
