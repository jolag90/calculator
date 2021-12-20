defmodule Calculator.CLI do
  def main(_args) do
    IO.puts("THE CALCULATOR")
    # init cal
    Calculator.start_link()
    |> loop()
  end

  defp loop({:ok, cal}) do
    print(cal)
    key = String.trim(IO.gets(""))

    unless key == "q" do
      Calculator.press_key(cal, key)
      loop({:ok, cal})
    end
  end

  defp print(cal) do
    IO.puts(Calculator.display(cal))
  end
end

# IO.gets(tastn & enter) |>String.trim(),.... noch schaun wia ma einzelnen tastn druck lesn ko
