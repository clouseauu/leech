defmodule Leech.Scraper.PropertyList do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  def list(property_list) do
    GenServer.call(property_list, { :list })
  end

  def fetch(property_list, url_list) do
    url_list |> Enum.each(fn(url) ->
      GenServer.cast(property_list, { :fetch, url })
    end)
  end

  def init(_) do
    { :ok, [] }
  end

  def handle_call({ :list }, _property_list, list) do
    { :reply, list, list }
  end

  def handle_cast({ :fetch, url }, state) do
    IO.inspect "fetching #{url}"
    list = url |> Leech.Scraper.ResultsPage.property_ids

    { :noreply, state ++ list }
  end
end
