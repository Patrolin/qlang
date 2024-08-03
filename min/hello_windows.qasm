target windows_x64
import:
  GetStdHandle?
  WriteFile?
relocs:
  %GetStdHandle = 0x2078, IMAGE_REL_BASED_DIR64; NOTE: windows specific
  %WriteFile = 0x2079, IMAGE_REL_BASED_DIR64
rdata:
  %msg = "Hello world!"
text:
  %0 = -11
  %stdOut = call GetStdHandle
  %0 = stdOut
  %1 = str
  %2 = 12
  %3 = 0
  %4 = 0
  call WriteFile
  ret
