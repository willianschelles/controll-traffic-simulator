defmodule CtaCongestionLevelBasedTest do
  use ExUnit.Case
  doctest CtaCongestionLevelBased

  describe "run/1" do
    test "runs the strategy for a scenario" do
      scenario = %{}
      assert CtaCongestionLevelBased.run(scenario) == :ok
    end
  end
end
