defmodule Intoable.MixProject do
  use Mix.Project

  @version "1.0.0"
  @source_url "https://github.com/Qarma-inspect/intoable"

  def project do
    [
      app: :intoable,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      consolidate_protocols: Mix.env() != :test,
      dialyzer: dialyzer(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "Intoable",
      source_url: @source_url
    ]
  end

  defp description do
    "A small helper for converting one struct into another in a uniform and convenient way."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG.md AGENT.md CLAUDE.md .formatter.exs)
    ]
  end

  defp docs do
    [
      main: "Intoable",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  defp dialyzer do
    [
      plt_local_path: "priv/plts",
      plt_core_path: "priv/plts",
      plt_add_apps: [:ex_unit, :mix],
      flags: [:error_handling, :extra_return, :missing_return, :unknown]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.34", only: [:dev, :test], runtime: false, warn_if_outdated: true},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  def cli do
    [
      preferred_envs: [
        dialyzer: :test
      ]
    ]
  end
end
