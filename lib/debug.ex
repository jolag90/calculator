defmodule Debug do
  @moduledoc """
  Quickly inject a debug-function into your module.

  ### Usage


      defmodule YourModule do
        use Debug, debug: true
        ...
      end

  or

      defmodule YourModule do
        use Debug, debug: false
        ...
      end

  in your module. Then you can use

      term |> debug()

  anywhere in your module and quickly switch from verbose to quiet mode by just
  change the line `use Debug, debug: YOUR_SETUP`.
  """
  defmacro __using__(opts \\ []) do
    quote do
      require Logger

      if unquote(opts[:debug]) do
        defp debug(arg) do
          Logger.info(inspect(arg))
          arg
        end
      else
        defp debug(arg), do: arg
      end
    end
  end
end
