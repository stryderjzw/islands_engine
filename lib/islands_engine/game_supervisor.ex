defmodule IslandsEngine.GameSupervisor do
  use DynamicSupervisor

  alias IslandsEngine.Game

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game(name) do
    child_spec = %{
      id: name,
      start: {Game, :start_link, [name]}
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop_game(name), do: DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end
