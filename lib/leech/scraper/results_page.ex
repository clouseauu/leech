defmodule Leech.Scraper.ResultsPage do
  use GenServer

  @link_selector ".photoviewer a"
  @link_filter ~r/-\d{5,}$/
  @timeout Application.get_env(:leech, :http_timeout)

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  def property_ids(results_page) do
    GenServer.call(results_page, { :property_ids }, @timeout)
  end

  def fetch_ids(results_page, url) do
    GenServer.cast(results_page, { :fetch_ids, url })
  end

  def init(state) do
    { :ok, state }
  end

  def handle_call({ :property_ids }, _from, state) do
    { :reply, state, state }
  end

  def handle_cast({ :fetch_ids, url }, state) do
    list = link_list(url)
    |> Enum.map(fn(link) -> link |> id_from_slug end)
    |> Enum.uniq

    { :noreply,  state ++ list }
  end

  defp id_from_slug(slug) do
    slug
    |> String.split("-")
    |> List.last
    |> Integer.parse
    |> elem(0)
  end

  defp link_list(url) do
    Leech.Scraper.Fetch.url(url)
    |> Floki.find(@link_selector)
    |> Floki.attribute("href")
    |> Enum.filter(&Regex.match?(@link_filter, &1))
  end
end
