defmodule Leech.Normalise do
  def url(string) when is_bitstring(string) do
    string |> String.downcase |> String.replace(" ", "+")
  end

  def url(number) when is_integer(number) do
    number |> Integer.to_string |> url
  end
end
