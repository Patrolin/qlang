from dataclasses import dataclass
from sys import argv

def main(src: str):
    # TODO: tokenize -> parse_ast -> typed_ir (-> sim) (-> opt) -> gen_llvm
    # https://llvm.org/docs/LangRef.html
    # TODO: run f"clang {name}.ll -o {name}.exe -nostdinc -nostdlib -nostdlib++ -no-integrated-cpp -z /subsystem:windows /entry:main -z User32.lib"
    ...

if __name__ == "__main__":
    main(argv[1])
