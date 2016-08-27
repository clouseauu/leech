defmodule Leech.Scraper.Urls do

  @defaults %{
    condition: :buy,
    type: [:all],
    min_bedrooms: 2,
    max_bedrooms: 4,
    min_price: 500000,
    max_price: :any
  }

  @base_url "http://www.realestate.com.au/"

  def generate(suburbs, options \\ %{}) do
    options = Map.merge(@defaults, options)
    suburbs |> Enum.map(fn(suburb) -> endpoint(suburb, options) end)
  end

  defp endpoint(suburb, options) do
    [
      @base_url,
      options[:condition],
      "/",
      options[:type] |> property_type,
      options[:min_bedrooms] |> min_bedrooms,
      price(options),
      suburb(suburb),
      "/list-1",
      "?",
      options[:max_bedrooms] |> max_bedrooms
    ]
    |> Enum.join("")
  end

  defp property_type(type) do
    "property-#{Enum.join(type, "-")}-"
  end

  defp min_bedrooms(0) do
    ""
  end

  defp min_bedrooms(bedrooms) do
    "with-#{bedrooms}-bedrooms-"
  end

  defp max_bedrooms(0) do
    ""
  end

  defp max_bedrooms(bedrooms) do
    "maxBeds=#{bedrooms}"
  end

  defp price(options) do
    cond do
      options[:min_price] == :any && options[:max_price] == :any ->
        ""
      true ->
        "between-#{options[:min_price]}-#{options[:max_price]}-"
    end
  end

  defp suburb(suburb) do
    suburb
    |> List.insert_at(0, "in")
    |> Enum.map(&(&1 |> Leech.Normalise.url))
    |> Enum.join("-")
  end
end


# /buy/with-2-bedrooms-between-500000-650000-in-coburg+vic+3058%3b/list-1?maxBeds=4
# "/sold/with-2-bedrooms-between-500000-700000-in-coburg%2c+vic+3058/list-1?maxBeds=4"
# "sold/property-townhouse-villa-with-2-bedrooms-between-200000-300000-in-upper+ferntree+gully%2c+vic+3156%3b/list-1?maxBeds=4"
# "/sold/with-2-bedrooms-in-coburg%2c+vic+3058/list-1?maxBeds=4&source=location-search"
