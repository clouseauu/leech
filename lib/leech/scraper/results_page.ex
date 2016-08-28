defmodule Leech.Scraper.ResultsPage do
  @link_selector ".photoviewer a"
  @link_filter ~r/-\d{5,}$/

  def property_ids(url) do
    link_list(url)
    |> Enum.map(fn(link) ->
      link |> id_from_slug
    end)
    |> Enum.uniq
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
