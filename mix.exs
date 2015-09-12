defmodule ChatbotDSLPlayground.Mixfile do
  use Mix.Project

  def project do
    [app: :chatbot_dsl_playground,
     name: "Chatbot DSL Playground",
     source_url: "http://github.com/knewter/chatbot_dsl_playground",
     homepage_url: "http://github.com/knewter/chatbot_dsl_playground",
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger, :hedwig, :exml],
      mod: {ChatbotDSLPlayground, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poison, "~> 1.5.0"},
      {:hedwig, "~> 0.1.0"},
      {:exml, github: "paulgray/exml"},
      {:inch_ex, only: :docs},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.8", only: :dev},
      {:dogma, github: "lpil/dogma", only: :dev}
    ]
  end
end
