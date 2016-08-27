defmodule Leech.Suburbs do

  @base_url "http://v0.postcodeapi.com.au"

  def by_postcode(postcode) do
    postcode
    |> parse
    |> Enum.map(
        fn(suburb)->
          [ suburb["name"], suburb["state"]["abbreviation"], postcode ]
        end
      )
  end

  defp parse(postcode) do
    { :ok, response } = postcode |> fetch
    Poison.decode! response.body
  end

  defp fetch(postcode) do
    postcode
    |> endpoint
    |> HTTPoison.get
  end

  defp endpoint(postcode) do
    "#{@base_url}/suburbs/#{postcode}.json"
  end
end


# coburg+vic+3058
