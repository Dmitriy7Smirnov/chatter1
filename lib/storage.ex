defmodule Storage do
  #include("stdlib/include/ms_transform.hrl")
  #Record.extract(:ms_transform, from_lib: "stdlib/include/ms_transform.hrl")
  import Ex2ms
  @compile {:parse_transform, :ms_transform}
  #include_lib("stdlib/include/ms_transform.hrl")
  use GenServer
  @ets_table :ets_storage

# Start the server
def start_link(_opts) do
  GenServer.start_link(__MODULE__, :ok, name: :myGenServer)
end


  # Callbacks

  @impl true
  def init(stack) do
    create_table()
    #send(self(), :init)
    {:ok, stack}
  end

  @impl true
  def handle_info(:init, state) do
    IO.inspect "IT IS HANDLE INFO INIT"
    #get_and_save()
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    IO.inspect "handle_info storage begin"
    IO.inspect msg
    IO.inspect "handle_info storage end"
    {:noreply, state}
  end

  # def get_and_save do
  #   hrefs = Parser.get_content()
  #   keys = %{href: "keys", hrefs: hrefs}
  #   create_data(keys)

  #   #Process.flag(:trap_exit, true)
  #   tasks = for href <- hrefs  do
  #       #:timer.sleep(50)
  #       if not get_data(href).show? do
  #         #spawn_link(Parser, :get_stars_test, [href])
  #         #spawn_monitor(Parser, :get_stars_floki, [href])
  #         Task.async(Parser, :get_stars_floki, [href])
  #       end
  #   end
  #   results = for task <- tasks do
  #     if task != nil do
  #       Task.await(task, 50000)
  #     end
  #   end
  #   for result <- results do
  #     if result != nil do
  #       add_stars(result.href, result.stars)
  #     end
  #   end
  #   IO.puts "tasks finished"
  # end


  def create_table do
    :ets.new(@ets_table, [:set, :public, :named_table])
    #:ets.new(:cool_table, [:bag, :public, :named_table])
  end

  def create_data(new_data) do
    #:ets.insert(@ets_table, {new_data.href, new_data})
    #new_data = %{topic: "topic", show?: false, name: "name", href: "href", stars: 777, description: "description"}
    #:ets.new(@ets_table, [:set, :named_table])
    :ets.insert_new(@ets_table, {new_data.href, new_data})
    #{"Actors", %{href: "Actors", show?: true, topic: "Actors"}}
  end

  def get_data(key) do
    # IO.inspect "WTF"
    # IO.inspect key
    # IO.inspect "WTF1"
    case :ets.lookup(@ets_table, key) do
      [tuple] -> {_head, tail} = tuple
                  tail
            _ -> %{topic: "topic", show?: false, name: "name", href: "href", stars: 777, description: "description"}
    end

  end

  def get_all_data(_hrefs) do
    :ets.match(@ets_table, '$1')
  end

  def update_stars(ktStruct) do
    key = ktStruct.href
    [{key, struct1}] = :ets.lookup(@ets_table, key)
    # IO.inspect "WTF"
    # IO.inspect map1
    # IO.inspect "WTF1"
    if is_map(struct1) do
      stars = ktStruct.stars
      map2 = Map.put(struct1, :stars, stars)
      :ets.insert(@ets_table, {key, map2})
    end
  end

end
