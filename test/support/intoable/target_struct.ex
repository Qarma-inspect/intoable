defmodule Intoable.TargetStruct do
  @moduledoc false

  use Intoable

  @type t :: %__MODULE__{
          name: String.t()
        }

  defstruct [:name]
end
