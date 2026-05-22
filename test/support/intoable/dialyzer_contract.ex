defmodule Intoable.DialyzerContract do
  @moduledoc """
  Compile-time / static-analysis fixture: exercises the overloaded `from/1`
  contract by piping its result into downstream consumers with narrow specs.

  This module is not invoked at runtime. Its purpose is to surface a Dialyzer
  warning if `TargetStruct.from/1` ever stops returning the type the user's
  downstream `@spec` expects.

  Concretely:
    * single-source path: `SourceStruct.t() -> TargetStruct.t() -> consume_one/1`
    * many-source path:   `[SourceStruct.t()] -> [TargetStruct.t()] -> consume_many/1`
  """

  alias Intoable.SourceStruct
  alias Intoable.TargetStruct

  @spec consume_one(TargetStruct.t()) :: String.t() | nil
  def consume_one(%TargetStruct{name: name}), do: name

  @spec consume_many([TargetStruct.t()]) :: non_neg_integer()
  def consume_many(list) when is_list(list), do: length(list)

  @spec round_trip_one(SourceStruct.t()) :: String.t() | nil
  def round_trip_one(source) do
    source
    |> TargetStruct.from()
    |> consume_one()
  end

  @spec round_trip_many([SourceStruct.t()]) :: non_neg_integer()
  def round_trip_many(sources) do
    sources
    |> TargetStruct.from()
    |> consume_many()
  end
end
