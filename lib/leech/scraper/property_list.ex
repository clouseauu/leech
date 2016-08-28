defmodule Leech.Scraper.PropertyList do
  use GenServer

  @timeout Application.get_env(:leech, :http_timeout)

  def start(url_list) do
    GenServer.start_link(__MODULE__, url_list)
  end

  def list(property_list) do
    GenServer.call(property_list, { :list }, @timeout)
  end

  def init(url_list) do
    state = url_list |> Enum.map(fn(url) ->
      { :ok, results_page } = Leech.Scraper.ResultsPage.start
      results_page |> Leech.Scraper.ResultsPage.fetch_ids(url)
      results_page
    end)

    { :ok, state }
  end

  def handle_call({ :list }, _property_list, state) do
    ids = state
    |> Enum.map(fn(worker) ->
      worker |> Leech.Scraper.ResultsPage.property_ids
    end)
    |> List.flatten
    |> Enum.uniq

    { :reply, ids, state }
  end
end
