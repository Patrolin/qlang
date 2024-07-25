// cl min/hello.c Kernel32.lib /link /entry:main
#include <windows.h>

const char str[12] = "Hello world!";
int main() {
  HANDLE stdOut = GetStdHandle(STD_OUTPUT_HANDLE);
  WriteFile(stdOut, str, 12, 0, 0);
}
