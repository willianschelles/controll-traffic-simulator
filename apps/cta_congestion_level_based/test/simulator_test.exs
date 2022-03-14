defmodule CtaSimulatorTest do
  use ExUnit.Case
  doctest CtaSimulator

  alias CtaCongestionLevelBased.Block

  describe "start/0" do
    test "stars the simulator and run it for total_time_in_seconds" do
      cta_simulator = %CtaSimulator{
        total_time_in_seconds: 20,
        area_of_actuation: 4,
        number_of_cars_to_add: 2,
        blocks: []
      }

      CtaSimulator.start(cta_simulator)
    end
  end
end
