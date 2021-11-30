defmodule Calculator do
  use Debug, debug: false

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

  def potentiate(n, x) when x > 0 do
    potentiate_calculation(n, n, x)
  end

  def potentiate(n, x) when x < 0 do
    potentiate_calculation_negative(1, n, x)
  end

  # _____________________________________________________________________

  defp potentiate_calculation(k, _, x) when x <= 1 do
    k |> debug()
  end

  defp potentiate_calculation(k, n, x) do
    potentiate_calculation(k * n, n, x - 1)
  end

  defp potentiate_calculation_negative(k, _, x) when x > -1 do
    k |> debug()
  end

  defp potentiate_calculation_negative(k, n, x) do
    potentiate_calculation_negative(k / n, n, x + 1)
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
  @doc """
  check if 'n' of power_of_ten is smaller, greater or equal to 0
  if greater then multiply 1 by 10 'n' times
  if smaller then divide 1 by 10 'n' times
  if 'n' == 0 commit 1
  """
  def power_of_ten(n) when n < 0 do
    power_of_ten_by_negative_n(1, n)
  end

  def power_of_ten(n) when n > 0 do
    power_of_ten_by_positive_n(1, n)
  end

  def power_of_ten(0), do: 1
  # _____________________________________________________________________

  defp power_of_ten_by_negative_n(k, n) when n < 0 do
    power_of_ten_by_negative_n(k / 10, n + 1)
  end

  defp power_of_ten_by_negative_n(k, _) do
    k
  end

  defp power_of_ten_by_positive_n(k, n) when n > 0 do
    power_of_ten_by_positive_n(k * 10, n - 1)
  end

  defp power_of_ten_by_positive_n(k, _) do
    k
  end
end
