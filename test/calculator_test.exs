defmodule CalculatorTest do
  use ExUnit.Case, async: false

  @nx [4, 6]
  @first_variable 6
  @second_variable 4
  test "sum up" do
    assert Calculator.sum(@nx) == 10
  end

  test "substract" do
    assert Calculator.sub(@nx) == -2
  end

  test "multiplicate" do
    assert Calculator.mult(@nx) == 24
  end

  test "division" do
    assert Calculator.div(@nx) == 2 / 3
  end

  test "square" do
    assert Calculator.square(@first_variable) == 36
  end

  test "reciprocal" do
    assert Calculator.reciprocal(@first_variable) == 1 / @first_variable
  end

  test "reciprocal with negative number" do
    assert Calculator.reciprocal(-10) == -1/10
  end

  test "potentiate" do
    assert Calculator.potentiate(@first_variable, @second_variable) == 1296
  end
  test "potentiate with negative power" do
  assert Calculator.potentiate(4,-2) == 625/10000
  end

  test "facultation" do
    assert Calculator.facultation(@first_variable) == 720
  end

  test "is prime number?" do
    assert Calculator.prime_number?(13)
  end

  test "10 to the power of" do
    assert Calculator.power_of_ten(@first_variable) == 1_000_000
  end
end
