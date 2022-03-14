defmodule CtaCongestionLevelBased.Vehicle do
  @moduledoc """
  Documentation for `CtaCongestionLevelBased.Vehicle`.
  """

  @type coordinate :: tuple()

  @type t :: %__MODULE__{
          id: integer(),
          # 0 or 20
          speed: integer(),
          aoa_position: coordinate
        }

  defstruct [
    :id,
    :speed,
    :aoa_position
  ]
end
