# defmodule Calculator.CLI do
#  def main(_args) do
#    IO.puts("THE CALCULATOR")
#    # init cal
#    Calculator.init()
#    |> loop()
#
#    # enter loop
#
#    # done
#  end
#
#  defp loop({:ok, cal}) do
#    cal
#    |> Calculator.key(String.trim(IO.gets("")))
#    |> print()
#    |> loop()
#  end
#
#  defp loop({:quit, _cal}), do: IO.puts("thanks")
#
#  defp print({_, cal} = state) do
#    IO.puts(cal.display)
#    state
#  end
# end
#
## IO.gets(tastn & enter) |>String.trim(),.... noch schaun wia ma einzelnen tastn druck lesn ko
