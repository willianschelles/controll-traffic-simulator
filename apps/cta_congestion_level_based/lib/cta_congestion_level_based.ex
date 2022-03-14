defmodule CtaCongestionLevelBased do
  @moduledoc """
  Documentation for `CtaCongestionLevelBased`.
  """

  @type t :: %__MODULE__{
          congestion_level: integer()
        }
  # 15 == N -> amount 60% of lane
  defstruct congestion_level: 15

  def run(%{} = scenario) do
  end

  def add_cars_to_entrypoints(number_of_cars) do
  end
end
