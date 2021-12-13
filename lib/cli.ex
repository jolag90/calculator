defmodule Calculator.CLI do
  def main(_args) do
    IO.puts("THE CALCULATOR")
    # init cal
    # enter loop
    # done
  end

  defp loop(cal) do
    cal
    |> Calculator.key("q")
    |> loop()
  end
end
