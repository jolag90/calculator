defmodule CalculatorTest do
  use ExUnit.Case, async: true

  describe "basics" do
    test ".start_link/0 .stop/1" do
      # Starting
      {:ok, pid} = Calculator.start_link()
      assert is_pid(pid)

      # Stopping
      assert Process.alive?(pid)
      Calculator.stop(pid)
      refute Process.alive?(pid)
    end

    test "newly started calculator displays 'Welcome!'" do
      {:ok, cal} = Calculator.start_link()
      assert Calculator.display(cal) == "Welcome!"
    end

    test "press number keys shows the number in display" do
      {:ok, cal} = Calculator.start_link()
      press_keys(cal, "123")
      assert Calculator.display(cal) == "123"
    end
  end

  describe "simple calculations" do
    setup _ do
      {:ok, pid} = Calculator.start_link()
      {:ok, %{cal: pid}}
    end

    test "enter number followed by a valid operator key", %{cal: cal} do
      press_keys(cal, "123")
      Calculator.press_key(cal, "+")
      assert Calculator.display(cal) == "123.0+"
    end

    test "enter number, operator, number, enter displays the result", %{cal: cal} do
      press_keys(cal, "123")
      Calculator.press_key(cal, "+")
      press_keys(cal, "123")
      Calculator.press_key(cal, "=")
      assert Calculator.display(cal) == "246.0"
    end

    test "continue after enter with next operator", %{cal: cal} do
      press_keys(cal, "123+123=+123.4=")
      assert Calculator.display(cal) == "369.4"
    end

    test "ignore unknown keys", %{cal: cal} do
      press_keys(cal, "   123 + 123 = + 123.4 =")
      assert Calculator.display(cal) == "369.4"
    end

    test "d=div operators", %{cal: cal} do
      press_keys(cal, "5 d 2=")
      assert Calculator.display(cal) == "2"
    end

    test "r=rem operators", %{cal: cal} do
      press_keys(cal, "5 r 2=")
      assert Calculator.display(cal) == "1"
    end
  end

  describe "Using two independent calculators" do
    setup _ do
      {:ok, cal1} = Calculator.start_link()
      {:ok, cal2} = Calculator.start_link()
      {:ok, %{c1: cal1, c2: cal2}}
    end

    test "two paralell calculators", %{c1: c1, c2: c2} do
      press_keys(c1, "1+2= +3= -1=")
      press_keys(c2, "1.4 / 2 =")

      assert Calculator.display(c1) == "5.0"
      assert Calculator.display(c2) == "0.7"
    end
  end

  defp press_keys(cal, keys) do
    String.split(keys, "", trim: true)
    |> Enum.each(fn key -> Calculator.press_key(cal, key) end)
  end
end
