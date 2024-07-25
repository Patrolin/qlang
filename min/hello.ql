WindowHandle :: distinct ptr
MessageBoxA :: foreign MessageBoxA(window_handle: WindowHandle, msg: cstring, title: cstring, options: i32) -> i32
print :: proc(str: cstring) {
  MessageBoxA(0, str, str, 0)
}
main :: proc "entry" () {
  print("hello world\n\0")
}


// str :: "hello world\n\0" // TODO: auto add null??
/*
phi :: proc(n: int) {
  acc: float = 2
  for {
    next := 1 + pow(acc, 1/n)
    if next == acc {ret next}
    acc = next
  }
}

getRoot :: proc(node: ^T) {
  for node.parent {
    node = node.parent
  }
  ret node
}
*/
