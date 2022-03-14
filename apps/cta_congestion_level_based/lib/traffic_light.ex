defmodule CtaCongestionLevelBased.TrafficLight do
  @moduledoc """
  Documentation for `CtaCongestionLevelBased.TrafficLight`.
  """

  alias CtaCongestionLevelBased.Vehicle

  @type t :: %__MODULE__{
          color: binary(),
          time: integer(),
          turns_percentage: Decimal.t(),
          vehicle_buffer: list(Vehicle.t())
        }

  defstruct [
    :color,
    :time,
    :turns_percentage,
    :vehicle_buffer
  ]
end
