defmodule CalculatorTest do
  use ExUnit.Case, async: true

  # test basic operations (+-*/)
  describe "basics" do
    test "%Calculator{} is a struct" do
      {:ok, calculator} = Calculator.init()
      assert calculator.display == "Welcome"
      assert calculator.register == 0.0
      assert calculator.operator == :idle
      assert calculator.input == ""
    end

    # test documented in detail as example
    test "enter keys '1 + 11.1 =' displays '12.1'" do
      # Initialize the calculator into `cal`
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      # Press a "1"
      {:ok,
       %Calculator{
         input: "1",
         display: "1"
       } = cal} = Calculator.key(cal, "1")

      # Press a "+"
      {:ok,
       %Calculator{
         input: "+",
         display: "1 + ",
         register: 1.0,
         operator: :add
       } = cal} = Calculator.key(cal, "+")

      # Press a "1"
      {:ok,
       %Calculator{
         input: "1",
         display: "1 + 1",
         register: 1.0,
         operator: :add
       } = cal} = Calculator.key(cal, "1")

      # Press another "1"
      {:ok,
       %Calculator{
         input: "11",
         display: "1 + 11",
         register: 1.0,
         operator: :add
       } = cal} = Calculator.key(cal, "1")

      # Press "."
      {:ok,
       %Calculator{
         input: "11.",
         display: "1 + 11.",
         register: 1.0,
         operator: :add
       } = cal} = Calculator.key(cal, ".")

      # Press another "1"
      {:ok,
       %Calculator{
         input: "11.1",
         display: "1 + 11.1",
         register: 1.0,
         operator: :add
       } = cal} = Calculator.key(cal, "1")

      # Press a "="
      {:ok,
       %Calculator{
         input: "=",
         display: "12.1",
         register: 12.1,
         operator: :idle
       } = _cal} = Calculator.key(cal, "=")
    end

    test "enter keys '3 - 4 =' displays '-1.0'" do
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      {:ok,
       %Calculator{
         input: "3",
         display: "3"
       } = cal} = Calculator.key(cal, "3")

      {:ok,
       %Calculator{
         input: "-",
         display: "3 - ",
         register: 3.0,
         operator: :sub
       } = cal} = Calculator.key(cal, "-")

      {:ok,
       %Calculator{
         input: "4",
         display: "3 - 4",
         register: 3.0,
         operator: :sub
       } = cal} = Calculator.key(cal, "4")

      {:ok,
       %Calculator{
         input: "=",
         display: "-1.0",
         register: -1.0,
         operator: :idle
       } = _cal} = Calculator.key(cal, "=")
    end

    test "enter keys '5 * 2 =' displays '10.0'" do
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      {:ok,
       %Calculator{
         input: "5",
         display: "5"
       } = cal} = Calculator.key(cal, "5")

      {:ok,
       %Calculator{
         input: "*",
         display: "5 * ",
         register: 5.0,
         operator: :mul
       } = cal} = Calculator.key(cal, "*")

      {:ok,
       %Calculator{
         input: "2",
         display: "5 * 2",
         register: 5.0,
         operator: :mul
       } = cal} = Calculator.key(cal, "2")

      {:ok,
       %Calculator{
         input: "=",
         display: "10.0",
         register: 10.0,
         operator: :idle
       } = _cal} = Calculator.key(cal, "=")
    end

    test "enter keys '5 / 2 =' displays '2.5'" do
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      {:ok,
       %Calculator{
         input: "5",
         display: "5"
       } = cal} = Calculator.key(cal, "5")

      {:ok,
       %Calculator{
         input: "/",
         display: "5 / ",
         register: 5.0,
         operator: :div
       } = cal} = Calculator.key(cal, "/")

      {:ok,
       %Calculator{
         input: "2",
         display: "5 / 2",
         register: 5.0,
         operator: :div
       } = cal} = Calculator.key(cal, "2")

      {:ok,
       %Calculator{
         input: "=",
         display: "2.5",
         register: 2.5,
         operator: :idle
       } = _cal} = Calculator.key(cal, "=")
    end
  end

  # test for errors
  describe "error handling" do
    test "unknown key pressed" do
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      {:ok,
       %Calculator{
         input: "",
         display: "Error"
       } = _cal} = Calculator.key(cal, "w")
    end

    # first input cannot be an operator
    test "unexpected key pressed" do
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      {:ok,
       %Calculator{
         input: "",
         display: "Error",
         state: :error,
         register: 0.0
       } = _cal} = Calculator.key(cal, "*")
    end

    # cannot deal with 2 opperators after each other
    test "2 time opperator pressed" do
      {:ok,
       %Calculator{
         input: "",
         display: "Welcome",
         register: 0.0
       } = cal} = Calculator.init()

      {:ok,
       %Calculator{
         input: "5",
         display: "5"
       } = cal} = Calculator.key(cal, "5")

      {:ok,
       %Calculator{
         input: "/",
         display: "5 / ",
         register: 5.0,
         operator: :div
       } = cal} = Calculator.key(cal, "/")

      {:ok,
       %Calculator{
         input: "",
         display: "Error",
         register: 0.0,
         operator: :idle,
         state: :error
       } = _cal} = Calculator.key(cal, "*")
    end
  end
end
