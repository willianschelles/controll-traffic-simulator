defmodule CtaSimulator do
  alias CtaCongestionLevelBased.{Block, Street, Vehicle, TrafficLight}

  @type t :: %__MODULE__{
          street: Street.t(),
          vehicles: list(Vehicle.t()),
          area_of_actuation: integer(),
          blocks: list(Block.t()),
          total_time_in_seconds: integer(),
          number_of_cars_to_add: integer(),
          congestion_level: integer()
        }

  defstruct [
    :street,
    :vehicles,
    :area_of_actuation,
    :blocks,
    :number_of_cars_to_add,
    :total_time_in_seconds,
    congestion_level: 3
  ]

  def start(%CtaSimulator{} = cta) do
    current_time = Time.utc_now()
    end_time = Time.add(current_time, cta.total_time_in_seconds, :second)

    IO.inspect(current_time, label: "\n\nstart simulation\n\n")

    simulate(cta, current_time, end_time)
  end

  def simulate(cta, current_time, end_time) do
    IO.inspect(Time.compare(current_time, end_time), label: "Time.compare(current_time, end_time)")

    if Time.compare(current_time, end_time) == :lt do
      :timer.sleep(1000)

      entrypoints = get_entrypoints(cta.area_of_actuation)
      blocks_with_cars = cta |> add_cars_to_blocks(entrypoints) |> Enum.reject(&is_nil/1)
      cta = append_cars_to_block(cta, blocks_with_cars)
      check_amount_cars_each_block(cta)

      # IO.inspect(cta, label: "Cta Simulator")
      current_time = Time.utc_now()
      simulate(cta, current_time, end_time)
    else
      IO.inspect(current_time, label: "\n\nend_of_simulation!!\n\n")
    end
  end

  defp append_cars_to_block(%CtaSimulator{} = cta, blocks_with_cars) do
    if Enum.empty?(cta.blocks) do
      Map.put(cta, :blocks, blocks_with_cars)
    else
      blocks =
        Enum.map(cta.blocks, fn block_from_cta ->
          [block_found | _] =
            Enum.filter(blocks_with_cars, fn block_with_cars ->
              block_with_cars.id == block_from_cta.id
            end)

          t1 =
            Map.put(
              block_from_cta.traffic_ligth_t1,
              :time,
              block_from_cta.traffic_ligth_t1.time - 1
            )

          t2 =
            Map.put(
              block_from_cta.traffic_ligth_t2,
              :time,
              block_from_cta.traffic_ligth_t2.time - 1
            )

          block_from_cta = Map.put(block_from_cta, :traffic_ligth_t1, t1)
          block_from_cta = Map.put(block_from_cta, :traffic_ligth_t2, t2)
          Map.put(block_from_cta, :vehicles, block_from_cta.vehicles ++ block_found.vehicles)
        end)

      Map.put(cta, :blocks, blocks)
    end
  end

  defp get_entrypoints(area_of_actuation) do
    entrypoints =
      1..area_of_actuation
      |> Enum.map(fn x ->
        if x <= area_of_actuation / 2, do: x + x
      end)
      |> Enum.reject(&is_nil/1)
  end

  @directions %{
    1 => "N",
    2 => "S",
    3 => "E",
    4 => "W"
  }

  defp add_cars_to_blocks(%CtaSimulator{} = cta, entrypoints) do
    blocks =
      # check if can add more cars (reached the limit?)
      for x <- 1..cta.area_of_actuation do
        cardeaul_point = get_cardeaul_points(x)
        entrypoint = Enum.at(entrypoints, x - 1)

        if not is_nil(entrypoint) do
          vehicles =
            for _x <- 1..cta.number_of_cars_to_add do
              %Vehicle{id: UUID.uuid4(), speed: 20}
            end

          t1 = %TrafficLight{color: "red", time: 47}

          %Block{id: x, vehicles: vehicles, length: 100, space: 100, traffic_ligth_t1: t1}
        end
      end
  end

  defp get_cardeaul_points(x) when rem(x - 1, 4) + 1 == 1, do: 1
  defp get_cardeaul_points(x) when rem(x - 1, 4) + 1 == 2, do: 2
  defp get_cardeaul_points(x) when rem(x - 1, 4) + 1 == 3, do: 3
  defp get_cardeaul_points(x) when rem(x - 1, 4) + 1 == 4, do: 4

  defp check_amount_cars_each_block(cta) do
    Enum.map(cta.blocks, fn block ->
      cond do
        # Rule 1
        length(block.vehicles) >= cta.congestion_level and
          block.traffic_ligth_t1.color == "red" and
            block.traffic_ligth_t1.time <= 40 ->
          t1 = Map.put(block.traffic_ligth_t1, :time, 30)
          Map.put(block, :traffic_ligth_t1, t1)

        # Rule 2
        length(block.vehicles) >= cta.congestion_level and
          block.traffic_ligth_t1.color == "red" and
            (block.traffic_ligth_t1.time > 25 and block.traffic_ligth_t1.time < 32) ->
          t2 = Map.put(block.traffic_ligth_t2, :color, "yellow")
          t1 = Map.put(block.traffic_ligth_t1, :time, 6)
          Map.put(block, :traffic_ligth_t2, t2)
          Map.put(block, :traffic_ligth_t1, t1)

        # Rule 3 - nothing performed
        length(block.vehicles) >= cta.congestion_level and
          block.traffic_ligth_t1.color == "red" and
            block.traffic_ligth_t1.time > 39 ->
          block

        # Rule 4 - nothing performed
        length(block.vehicles) >= cta.congestion_level and
            (block.traffic_ligth_t1.color == "yellor" or
               block.traffic_ligth_t1.color == "green") ->
          block

        true ->
          block
      end
    end)
  end
end
