defmodule CtaCongestionLevelBased.Street do
  @moduledoc """
  Documentation for `CtaCongestionLevelBased.Street`.
  """
  alias CtaCongestionLevelBased.{Vehicle, TrafficLight}

  @type t :: %__MODULE__{
          direction: String.t(),
          lanes: integer(),
          id: integer()
        }

  defstruct [
    :direction,
    :id,
    lanes: 2
  ]
end
