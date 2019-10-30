defmodule Crawler do
  @moduledoc """
  Crawler keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use GenServer

  def start_link(_init_args) do
    GenServer.start_link(__MODULE__, :ok, name: :myCrawler)
  end

  # Callbacks

  @impl true
  def init(stack) do
    IO.inspect "CRAWLER INITED"
    send(self(), :crawl)
    {:ok, stack}
  end

  @impl true
  def handle_info(:crawl, state) do
    IO.inspect "CRAWLER HAD CRAWLED"
    # In 24 hours
    #Storage.get_and_save()
    #Parser.get_content()
    parserStructs = Parser.get_content()
    Enum.map(parserStructs, &Storage.create_data/1)
    # hrefs = Enum.map(parserStructs, fn x -> x.href end)
    # IO.inspect hrefs
    Process.flag(:trap_exit, true)
    stream = Task.async_stream(parserStructs, Parser, :get_stars_floki, [], [max_concurrency: 10, ordered: false, timeout: 50000])
    #stream = Task.async_stream(parserStructs, &Parser.get_stars_floki, fn x -> [x.href] end, [max_concurrency: 10, ordered: false])
    stars = Enum.to_list(stream)
    stars1 = Utils.get_stars_time_ok_status(stars)

    Enum.map(stars1, &Storage.update_stars/1)
    #IO.inspect stars1
    # for item <- parserStructs do
    #   IO.inspect item
    #   Storage.create_data(item)
    # end
    Process.send_after(self(), :crawl, 24 * 60 * 60 * 1000)
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state) do
    IO.inspect "CRAWLER HAD CRAWLED _msg"
    {:noreply, state}
  end

end
