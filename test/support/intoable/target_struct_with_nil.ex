defmodule Intoable.TargetStructWithNil do
  @moduledoc false

  use Intoable, allow_nil?: true

  @type t :: %__MODULE__{
          name: String.t()
        }

  defstruct [:name]
end
