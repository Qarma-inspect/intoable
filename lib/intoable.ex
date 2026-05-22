defmodule Intoable do
  @moduledoc ~S"""
  A small helper for converting one struct into another in a uniform and convenient way.

  When `use`'d inside a `TargetStruct` module, it will generate a `TargetStruct.Into` protocol
  and add a `from/1` function to the TargetStruct. For any `SourceStruct` having
  a `TargetStruct.Into` protocol implementation it is possible to create a `TargetStruct` struct
  from a `SourceStruct` struct by calling `TargetStruct.from/1`.

  `TargetStruct.Into` protocol has default implementation for lists which iterates through a list and
  calls the same `TargetStruct.from/1` function for each list item.

  If `allow_nil?: true` is passed as option with `use #{__MODULE__}, allow_nil?: true`,
  `TargetStruct.from/1` will also accept `nil` and return `nil`.

  ## Examples

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

  """

  defmacro __using__(opts \\ []) do
    # Let's allow only `true` to add default Into protocol implementation for `nil` source
    allow_nil? = Keyword.get(opts, :allow_nil?, false) == true

    intoable_struct_module = __CALLER__.module

    quote location: :keep do
      defprotocol Into do
        @moduledoc """
        A helper protocol to convert a `SourceStruct` struct into a `#{unquote(intoable_struct_module)}` struct.
        Please check `Intoable` docs for more information.
        """

        @spec from(__MODULE__.t()) :: unquote(intoable_struct_module).t()
        @spec from([__MODULE__.t()]) :: [unquote(intoable_struct_module).t()]
        # `Protocol.def/1` is used instead of plain `def from(source)`: when this
        # block is generated via `quote`, a bodyless `def` is expanded by `Kernel.def`
        # before `defprotocol` can intercept it, which fails with
        # "implementation not provided for predefined def from/1". The explicit
        # `Protocol.def` bypasses that and registers the protocol function directly.
        Protocol.def(from(source))
      end

      defimpl Into, for: List do
        def from(sources), do: Enum.map(sources, &unquote(intoable_struct_module).from/1)
      end

      @doc """
      Creates a `#{__MODULE__}` struct from a `SourceStruct` struct by using `#{__MODULE__}.Into` protocol.

      Please check `Intoable` docs for more information.
      """
      if unquote(allow_nil?) do
        @spec from(source :: nil) :: nil
        def from(nil), do: nil
      end

      @spec from(source :: __MODULE__.Into.t()) :: __MODULE__.t()
      @spec from(sources :: [__MODULE__.Into.t()]) :: [__MODULE__.t()]
      def from(source), do: __MODULE__.Into.from(source)
    end
  end
end
