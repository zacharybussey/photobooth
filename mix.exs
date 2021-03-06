defmodule Photobooth.Mixfile do
  use Mix.Project

  def project do
    [app: :photobooth,
     version: "0.0.1",
     elixir: "~> 0.15.1",
     escript: escript_config,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [],
      mod: {Photobooth, []}
    ]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
  [
    {:elixir_ale, github: "fhunleth/elixir_ale"}
  ]
  end

  defp escript_config do
    [ main_module: Photobooth.CLI ]
  end
end
