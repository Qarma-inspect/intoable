defmodule Intoable.SourceStruct do
  @moduledoc false

  @type t :: %__MODULE__{
          other_name: String.t()
        }

  defstruct [:other_name]
end
