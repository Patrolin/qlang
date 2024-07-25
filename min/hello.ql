WindowHandle :: distinct ptr
@(reloc="user32.lib")
MessageBoxA :: proc MessageBoxA(window_handle: WindowHandle, msg: cstring, title: cstring, options: i32): i32

@(entry)
main :: proc() {
  MessageBoxA(0, "hello world\n\0", 0, 0)
}
