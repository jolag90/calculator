defmodule Calculator do
  use Debug, debug: false

  @number_keys ~w/0 1 2 3 4 5 6 7 8 9 ./
  @enter_key "="
  @operator_keys ~w(+ * / -)
  @operator_map %{"+" => :add, "-" => :sub, "*" => :mul, "/" => :div}
  @state1 :input_reg_1
  @state2 :input_operator
  @state3 :input_reg_2

  defstruct display: "Welcome",
            register: 0.0,
            operator: :idle,
            input: "",
            state: @state1,
            initial_input: 0

  def init() do
    {:ok, %__MODULE__{}}
  end

  def key(cal, key_pressed)

  def key(cal, num_key) when num_key in @number_keys and cal.state in [@state1, @state3] do
    {:ok,
     %{
       cal
       | input: append_input(cal.input, num_key),
         display: append_key(cal.display, num_key),
         initial_input: "true"
     }}
  end

  def key(cal, operator_key) when operator_key in @operator_keys and cal.state == @state1 and cal.initial_input == "true" do
    {:ok,
     %{
       cal
       | input: operator_key,
         register: parse_input(cal.input) || 0,
         operator: Map.get(@operator_map, operator_key),
         display: append_key(cal.display, " #{operator_key} "),

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
         state: @state1,
         display: "#{result}"
     }}
  end

  def key(%__MODULE__{}, _) do
    {:ok,
     %{
       reset()
       | display: "Error",
         state: :error
     }}
  end

  defp reset do
    %__MODULE__{}
  end

  defp parse_input(input) do
    case Float.parse(input) do
      {f, _} when is_number(f) ->
        f

      invalid_input ->
        debug("Invalid Input #{inspect(invalid_input)}")
        nil
    end
  end

  defp append_key(display, num_key) do
    "#{display |> String.replace("Welcome", "")}#{num_key}"
  end

  defp append_input(input, num_key) do
    remove_chars(input) <> num_key
  end

  defp remove_chars(input) do
    value = String.split(input, "")

    Enum.reduce(value, [], fn ops, acc ->
      append_if_not_operator(acc, ops)
    end)
    |> Enum.join()
  end

  defp append_if_not_operator(acc, ops) when ops not in @operator_keys do
    acc ++ [ops]
  end

  defp append_if_not_operator(acc, _) do
    acc
  end

  defp calculate(operator, register, input) when operator == :add do
    register + (parse_input(input) || 0)
  end

  defp calculate(operator, register, input) when operator == :sub do
    register - (parse_input(input) || 0)
  end

  defp calculate(operator, register, input) when operator == :mul do
    register * (parse_input(input) || 1)
  end

  defp calculate(operator, register, input) when operator == :div do
    register / (parse_input(input) || 1)
  end

  defp calculate(operator, _, _) when operator not in @operator_keys do
    IO.puts("Invalid Operator: #{operator}")
    nil
  end
end
