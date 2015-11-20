defmodule SCC do
  alias SCC.VisitedSet
  alias SCC.FinishTimes
  alias SCC.Graph
  alias SCC.LeaderSet

  def find_times do
    VisitedSet.start
    FinishTimes.start
    max = Graph.max
    vertices = Enum.into(1..max, []) |> Enum.reverse
    
    Enum.each(vertices, fn(vertice) ->
      unless VisitedSet.visited?(vertice) do
        VisitedSet.visit(vertice)
        find_last_reverse(vertice)
      end
    end)
  end

  def find_last_reverse(vertice) do
    not_visited = Graph.ways_to(vertice)
    |> Enum.filter(&VisitedSet.visited?(&1) == false)

    if length(not_visited) > 0 do
      Enum.each(not_visited, &VisitedSet.visit(&1))
      Enum.each(not_visited, fn(vert) ->
        find_last_reverse(vert)
      end)
    end

    FinishTimes.set(vertice, FinishTimes.last_time + 1)
  end

  def find_scc do
    VisitedSet.reset
    LeaderSet.start
    max = Graph.max
    vertices = Enum.into(1..max, []) |> Enum.reverse

    Enum.each(vertices, fn(vertice) ->
      unless VisitedSet.visited?(vertice) do
        VisitedSet.visit(vertice)
        find_for_leader(vertice, vertice)
      end
    end)
  end

  def find_for_leader(vertice, leader) do
    not_visited = Graph.ways_from(vertice)
    |> Enum.filter(&VisitedSet.visited?(&1) == false)

    if length(not_visited) > 0 do
      Enum.each(not_visited, &VisitedSet.visit(&1))
      Enum.each(not_visited, fn(vert) ->
        find_for_leader(vert, leader)
      end)
    end

    LeaderSet.add(leader, vertice)
  end


  defmodule Graph do
    def init(list), do: Agent.start_link(fn -> list end, name: __MODULE__)

    def get, do:  Agent.get(__MODULE__, &(&1))

    def set(list), do: Agent.update(__MODULE__, fn(_) -> list end)

    def set_ways_to(dict), do: Agent.start_link(fn -> dict end, name: :ways_to)

    def get_ways_to(vertice), do: Agent.get(:ways_to, &Dict.get(&1, vertice, []))

    def set_ways_from(dict), do: Agent.start_link(fn -> dict end, name: :ways_from)

    def get_ways_from(vertice), do: Agent.get(:ways_from, &Dict.get(&1, vertice, []))

    def max do
      get |> Enum.reduce(0, fn({l, r}, acc) ->
        m = max(l, r)
        if m > acc, do: m, else: acc
      end)
    end

    def ways_from(vertice), do: Enum.reverse(get_ways_from(vertice))

    def ways_to(vertice), do: Enum.reverse(get_ways_to(vertice))

    def calc_all_ways_to do
      dict = Enum.reduce(get, HashDict.new, fn({l, r}, dict) ->
        ways = Dict.get(dict, r) || []
        Dict.put(dict, r, [l|ways])
      end)
      set_ways_to(dict)
    end

    def calc_all_ways_from do
      dict = Enum.reduce(get, HashDict.new, fn({l, r}, dict) ->
        ways = Dict.get(dict, l) || []
        Dict.put(dict, l, [r|ways])
      end)
      set_ways_from(dict)
    end

    def times_graph do
      Enum.map(get, fn({l, r}) ->
        {SCC.FinishTimes.get(l), SCC.FinishTimes.get(r)}
      end)
    end
  end

  defmodule VisitedSet do
    def start, do:  Agent.start_link(fn -> HashSet.new end, name: __MODULE__)

    def stop, do: Agent.stop(__MODULE__)

    def reset, do: Agent.update(__MODULE__, fn(_) -> HashSet.new end)

    def visit(vertice), do: Agent.update(__MODULE__, &Set.put(&1, vertice))

    def visited?(vertice), do: Agent.get(__MODULE__, &Set.member?(&1, vertice))
  end

  defmodule FinishTimes do
    def start, do: Agent.start_link(fn -> HashDict.new end, name: __MODULE__)

    def stop, do: Agent.stop(__MODULE__)

    def set(vertice, time) do
      Agent.update(__MODULE__, &Dict.put(&1, vertice, time))
      Agent.update(__MODULE__, &Dict.put(&1, :last_time, time))
    end

    def get(vertice), do: Agent.get(__MODULE__, &Dict.get(&1, vertice))

    def last_time, do: get(:last_time) || 0
  end

  defmodule LeaderSet do
    def start, do: Agent.start_link(fn -> HashDict.new end, name: __MODULE__)

    def stop, do: Agent.stop(__MODULE__)

    def add(leader, vertice) do
      count = Agent.get(__MODULE__, &Dict.get(&1, leader)) || 0
      Agent.update(__MODULE__, &Dict.put(&1, leader, count + 1))
    end

    def get(vertice), do: Agent.get(__MODULE__, &Dict.get(&1, vertice))

    def leaders, do: Agent.get(__MODULE__, &Dict.keys(&1))
  end
end
