// clang -S -emit-llvm ctest.c -o ctest.ll
#include <windows.h>

const char str[12] = "Hello world\0";

int main() {
    MessageBoxA(0, str, str, 64);
}
