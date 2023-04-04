void osPrint(String str)
void osExit(int return_code)

if (OS_LINUX)
    // sysvCall: rdi, rsi, rcx, r10, r8, r9
    void osPrint(String str)
        linuxWrite(2, str.data, str.count);
    uint sysvCall linuxWrite(uint fd, u8* buf, uint count)
        asm
            syscall
    void sysvCall osExit(int return_code)
        asm
            syscall
elif (OS_WINDOWS)
    // winX64Call: https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention
    //   =rax/xmm0, unless it's a pointer, then =rcx
    //   rcx, rdx, r8, r9, <optional>, ...stack(shadow_store,rtl) (integers/log2 structs)
    //   rcx+xmm0, rdx+xmm1, r8+xmm2, r9+xmm3 (floats)
    // winStdCall: ...stack (rtl)
    #include <windows.h>
    void osPrint(String str)
        MessageBoxA(0, str.data, "Message", MB_OK);
    void osExit(int return_code)
        ExitProcess(0)
