# AGENT.md

`intoable` provides a uniform `from/1` for struct-to-struct conversion in Elixir.

## Usage

```elixir
defmodule UserDTO do
  use Intoable
  defstruct [:name]
end

defimpl UserDTO.Into, for: User do
  def from(%User{first_name: n}), do: %UserDTO{name: n}
end

UserDTO.from(%User{first_name: "Ada"})    # %UserDTO{name: "Ada"}
UserDTO.from([%User{first_name: "Ada"}])  # [%UserDTO{name: "Ada"}]
```

## Options

`use Intoable, allow_nil?: true` makes `UserDTO.from(nil)` return `nil` instead of raising.

## Pitfalls

- Always call `Target.from/1`, not `Target.Into.from/1`. Only the outer `Target.from/1` handles `nil` and lists.
- Without `allow_nil?: true`, `Target.from(nil)` raises `Protocol.UndefinedError`.

Full reference: <https://hexdocs.pm/intoable>.
