defmodule Init.MixProject do
  use Mix.Project

  @vsn "1.0.0"

  def project do
    [
      app: :init,
      version: @vsn,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
