from typing import TypeVar

T = TypeVar("T")

def fail(message: str):
    raise Exception(message)

def assert_equals(got: T, expected: T):
    if got != expected:
        fail(f"got: {got}; expected: {expected}")
