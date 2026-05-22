# Intoable

[![CI](https://github.com/Qarma-inspect/intoable/actions/workflows/ci.yml/badge.svg)](https://github.com/Qarma-inspect/intoable/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/intoable.svg)](https://hex.pm/packages/intoable)
[![HexDocs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/intoable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A small helper for converting one struct into another in a uniform and convenient way.

## Rationale

I got tired of different methods developers used to transform one structure to another
in projects I was working with, all of those `as_something`, `to_something`, `convert`, `transform`,
where all of those can coexist in the same project, and it is almost impossible to know where it is
located (in the source module, in the target module, in some external to both modules), which
direction it transforms et cetera, et cetera.

This library is the result - a uniform way to achieve the same goal.

## Usage and behaviour

When `use`'d inside a `TargetStruct` module, it will generate a `TargetStruct.Into` protocol
and add a `from/1` function to the TargetStruct. For any `SourceStruct` having
a `TargetStruct.Into` protocol implementation it is possible to create a `TargetStruct` struct
from a `SourceStruct` struct by calling `TargetStruct.from/1`.

`TargetStruct.Into` protocol has a default implementation for `List`s which iterates through a list and
calls the same `TargetStruct.from/1` function for each list item.

If `allow_nil?: true` is passed as option with `use Intoable, allow_nil?: true`,
`TargetStruct.from/1` will also accept `nil` and return `nil`.

## Examples

Please check `test/support/intoable` directory for structs internals.

```elixir
      iex> alias Intoable.{TargetStruct, TargetStructWithNil, SourceStruct, AnotherStruct}
      iex>
      iex> defimpl TargetStruct.Into, for: SourceStruct do
      ...>   def from(%SourceStruct{} = source), do: %TargetStruct{name: source.other_name}
      ...> end
      iex>
      iex> source = %SourceStruct{other_name: "foo"}
      %SourceStruct{other_name: "foo"}
      iex>
      iex> %TargetStruct{name: "foo"} = TargetStruct.from(source)
      %TargetStruct{name: "foo"}
      iex>
      iex> [%TargetStruct{name: "foo"}] = TargetStruct.from([source])
      [%TargetStruct{name: "foo"}]
      iex>
      iex> another_struct = %AnotherStruct{new_name: "bar"}
      iex> assert_raise Protocol.UndefinedError, fn -> TargetStruct.from(another_struct) end
      iex>
      iex> assert_raise Protocol.UndefinedError, fn -> TargetStruct.from(nil) end
      iex>
      iex> nil = TargetStructWithNil.from(nil)
      nil
      iex> [nil] = TargetStructWithNil.from([nil])
      [nil]
```

## Requirements

- Elixir `~> 1.15`
- OTP `26` or later is recommended. On OTP `25` and earlier, Dialyzer emits
  spurious `overlapping_contract` warnings on every `use Intoable` callsite
  in downstream projects. The library itself works correctly on OTP `25`,
  it is purely a Dialyzer-output cosmetic issue.

## Installation

```elixir
def deps do
  [
    {:intoable, "~> 1.0.0"}
  ]
end
```
