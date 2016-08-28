Application.start :hound

defmodule Leech.Scraper.Fetch do
  use Hound.Helpers

  def url(url) do
    Hound.start_session
    navigate_to url
    source = page_source()
    Hound.end_session
    source
  end
end
