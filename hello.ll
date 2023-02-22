; hello world in 2560 B
@.str = private unnamed_addr constant [13 x i8] c"hello world\0A\00"

%Opaque = type opaque

declare i32 @MessageBoxA(%Opaque* %window_handle, i8* %message, i8* %title, i32 %options)

define i32 @main() {
    %cast1 = getelementptr [13 x i8],[13 x i8]* @.str, i64 0, i64 0
    %null_ptr = inttoptr i64 0 to %Opaque*
    call i32 @MessageBoxA(%Opaque* %null_ptr, i8* %cast1, i8* %cast1, i32 64)
    ret i32 0
}
