defmodule Calculator do
  use Debug, debug: false

  @number_keys ~w/0 1 2 3 4 5 6 7 8 9 ./
  @enter_key "="
  @operator_keys ~w(+ * / -)
  @operator_map %{"+" => :add, "-" => :sub, "*" => :mul, "/" => :div}

  defstruct display: "Welcome",
            register: 0.0,
            operator: :idle,
            input: "",
            state: :input

  def init() do
    {:ok, %__MODULE__{}}
  end

  def key(cal, num_key) when num_key in @number_keys do
    {:ok,
     %{
       cal
       | input: append_input(cal.input, num_key),
         display: append_key(cal.display, num_key)
     }}
  end

  def key(cal, operator_key) when operator_key in @operator_keys do
    {:ok,
     %{
       cal
       | input: operator_key,
         register: parse_input(cal.input),
         operator: Map.get(@operator_map, operator_key),
         display: append_key(cal.display, " #{operator_key} ")
     }}
  end

  def key(cal, operator_key) when operator_key == @enter_key do
    result = calculate(cal.operator, cal.register, cal.input)

    {:ok,
     %{
       cal
       | input: @enter_key,
         register: result,
         operator: :idle,
         state: :input,
         display: "#{result}"
     }}
  end

  def key(%__MODULE__{} = cal, key) do
    IO.puts("Invalid input '#{key}'")
    {:ok, cal}
  end

  defp parse_input(input) do
    case Float.parse(input) do
      {f, _} when is_number(f) ->
        f

      invalid_input ->
        IO.puts("Invalid Input #{inspect(invalid_input)}")
        ""
    end
  end

  defp append_key(display, num_key) do
    "#{display |> String.replace("Welcome", "")}#{num_key}"
  end

  defp append_input(input, num_key) do
    {:ok, regex} = Regex.compile("[#{@operator_keys}]")
    "#{String.replace(input, regex, "")}#{num_key}"
  end

  defp calculate(operator, register, input) when operator == :add do
    register + parse_input(input)
  end

  defp calculate(operator, register, input) when operator == :sub do
    register - parse_input(input)
  end

  defp calculate(operator, register, input) when operator == :mul do
    register * parse_input(input)
  end

  defp calculate(operator, register, input) when operator == :div do
    register / parse_input(input)
  end

  defp calculate(operator, _, _) when operator not in @operator_keys do
    IO.puts("Invalid Operator: #{operator}")
  end
end
