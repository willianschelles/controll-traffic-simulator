defmodule CtaCongestionLevelBased.Block do
  @moduledoc """
  Documentation for `CtaCongestionLevelBased.Block`.
  """
  alias CtaCongestionLevelBased.{Vehicle, TrafficLight}

  @type t :: %__MODULE__{
          length: integer(),
          # 25 * lanes
          space: integer(),
          vehicles: list(Vehicle.t()),
          traffic_ligth_t1: TrafficLight.t(),
          traffic_ligth_t2: TrafficLight.t(),
          id: integer()
        }

  defstruct [
    :length,
    :space,
    :vehicles,
    :id,
    traffic_ligth_t1: %TrafficLight{
      color: "red",
      time: 47
    },
    traffic_ligth_t2: %TrafficLight{
      color: "green",
      time: 38
    }
  ]
end
