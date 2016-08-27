defmodule Leech.Fetcher do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, [])
  end

  # def fetch(type // :buy) do
  # end



end
