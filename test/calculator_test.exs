defmodule CalculatorTest do
  use ExUnit.Case, async: true

  test "%Calculator{} is a struct" do
    {:ok, calculator} = Calculator.init()
    assert calculator.display == "Welcome"
    assert calculator.register == 0
    assert calculator.operator == :idle
    assert calculator.input == ""
    assert calculator.state == :input
  end

  test "enter keys '1 + 11 =' displays '12'" do
    # Initialize the calculator into `cal`
    {:ok,
     %Calculator{
       input: "",
       display: "Welcome",
       register: 0,
       state: :input
     } = cal} = Calculator.init()

    # Press a "1"
    {:ok,
     %Calculator{
       input: "1",
       display: "1",
       state: :input
     } = cal} = Calculator.key(cal, "1")

    # Press a "+"
    {:ok,
     %Calculator{
       input: "+",
       display: "1 + ",
       register: 1,
       operator: :add,
       state: :input
     } = cal} = Calculator.key(cal, "+")

    # Press a "1"
    {:ok,
     %Calculator{
       input: "1",
       display: "1 + 1",
       register: 1,
       operator: :add,
       state: :input
     } = cal} = Calculator.key(cal, "1")

    # Press another "1"
    {:ok,
     %Calculator{
       input: "11",
       display: "1 + 11",
       register: 1,
       operator: :add,
       state: :input
     } = cal} = Calculator.key(cal, "1")

    # Press a "="
    {:ok,
     %Calculator{
       input: "=",
       display: "12",
       register: 12,
       operator: :idle,
       state: :input
     } = _cal} = Calculator.key(cal, "=")
  end
end
