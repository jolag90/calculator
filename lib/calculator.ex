defmodule Calculator do
  @debug true
  require Logger
  def sum([]), do: 0

  def sum([n | rest]) do
    (n + sum(rest))
    |> debug()
  end

  def sub([]), do: 0

  def sub([n | rest]) do
    (n - sub(rest))
    |> debug()
  end

  def mult([]), do: 1

  def mult([n | rest]) do
    (n * mult(rest))
    |> debug()
  end

  def div([]), do: 1

  def div([n | rest]) do
    (n / div(rest))
    |> debug()
  end

  def square(n), do: (n * n) |> debug()

  def reciprocal(n) when n != 0, do: (1 / n) |> debug()

  def reciprocal(_) do
    IO.puts("divide by zero is not defined")
  end

  #######################################################################
  def potentiate(_, 0), do: 1

  def potentiate(n, x) do
    potentiate_calculation(n, n, x)
  end

  # _____________________________________________________________________

  defp potentiate_calculation(k, _, x) when x <= 1 do
    k |> debug()
  end

  defp potentiate_calculation(k, n, x) do
    potentiate_calculation(k * n, n, x - 1)
  end

  #######################################################################
  def facultation([]), do: 1

  def facultation(n) do
    facultation_calculation(1, n)
  end

  # _____________________________________________________________________
  defp facultation_calculation(f, n) when n <= 1, do: f |> debug()

  defp facultation_calculation(f, n) do
    facultation_calculation(f * n, n - 1)
  end

  #######################################################################
  def prime_number?(n) do
    prime_number_calculation(2, n)
  end

  # _____________________________________________________________________
  defp prime_number_calculation(divisor, n) when divisor <= n / 2 do
    dividable_by_divisor(n, divisor)
  end

  defp prime_number_calculation(_, _) do
    true |> debug()
  end

  defp dividable_by_divisor(n, divisor) when rem(n, divisor) == 0 do
    false |> debug()
  end

  defp dividable_by_divisor(n, divisor) do
    prime_number_calculation(divisor + 1, n)
  end

  #######################################################################


  if @debug do
    defp debug(arg) do
      Logger.info(inspect(arg))
      arg
    end
  else
    defp debug(arg), do: arg
  end
end
