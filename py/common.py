from typing import TypeVar

T = TypeVar("T")

# assert
def fail(message: str):
    raise Exception(message)

def assert_equals(got: T, expected: T):
    if got != expected:
        fail(f"got: {got}; expected: {expected}")

# slice
class Slice:
    def __init__(self, data: str, start=0, end=-1):
        self.data = data
        self.start = start
        self.end = end if end >= 0 else len(data)

    def __repr__(self) -> str:
        return f"Slice({repr(self.data[self.start:self.end])}, {self.start}..{self.end})"

    def __getitem__(self, i: int):
        return self.data[i]
