defmodule MkmAPI.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mkm_api,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:db, in_umbrella: true},
      {:timex, "~> 3.0"},
      {:mkm, github: "naps62/mkm", ref: "badb8c2"}
    ]
  end
end
