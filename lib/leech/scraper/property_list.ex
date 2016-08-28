defmodule Leech.Scraper.PropertyList do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  def list(property_list) do
    GenServer.call(property_list, { :list })
  end

  def fetch(property_list, url_list) do
    GenServer.cast(property_list, { :fetch, url_list })
  end

  def init(_) do
    { :ok, [] }
  end

  def handle_call({ :list }, _property_list, list) do
    { :reply, list, list }
  end

  def handle_cast({ :fetch, url_list }, state) do
    list = url_list
    |> List.first
    |> Leech.Scraper.ResultsPage.property_ids

    { :noreply, state ++ list }
  end
end
