defmodule Calculator do
  use Debug, debug: false

  @number_keys ~w/0 1 2 3 4 5 6 7 8 9 ./
  @enter_key "="
  @quit_key "q"
  @operator_keys ~w(+ * / -)
  @operator_map %{"+" => :add, "-" => :sub, "*" => :mul, "/" => :div}
  @state1 :input_register
  @state2 :input_operator

  # FIXME: :got_number? shouldn't be visible in Calculator's API
  defstruct display: "Welcome",
            register: 0.0,
            operator: :idle,
            input: "",
            state: @state1,
            got_number?: false

  def init() do
    {:ok, %__MODULE__{}}
  end

  def key(cal, key_pressed) do
    handle_key(cal, key_pressed)
  end

  ######################################################################

  defp handle_key(cal, operator_key) when operator_key == @quit_key do
    {:quit, cal}
  end

  # match if a num_key was pressed. Appends the new key to display and input
  defp handle_key(cal, num_key) when num_key in @number_keys do
    {:ok,
     %{
       cal
       | input: append_input(cal.input, num_key),
         display: append_key(cal.display, num_key),
         got_number?: true,
         state: @state1
     }}
  end

  # match operator_key if any number was entered before.
  # parse number from input into register
  # sets operator and input
  # appends key to display
  defp handle_key(cal, operator_key)
       when operator_key in @operator_keys and cal.got_number? and cal.state != @state2 do
    {:ok,
     %{
       cal
       | input: operator_key,
         register: parse_input(cal.input) || 0,
         operator: Map.get(@operator_map, operator_key),
         display: append_key(cal.display, " #{operator_key} "),
         state: @state2
     }}
  end

  # when enter was pressed calculate
  # - set result to display and reset all other fields
  defp handle_key(cal, operator_key) when operator_key == @enter_key do
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

  # catch all - reset and display error
  defp handle_key(%__MODULE__{}, _) do
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

  # to convert strings into floats from register(for calculation purpose)
  defp parse_input(input) do
    case Float.parse(input) do
      {f, _} when is_number(f) ->
        f

      invalid_input ->
        debug("Invalid Input #{inspect(invalid_input)}")
        nil
    end
  end

  # to insert the input on the display (&remove "welcome")
  defp append_key(display, num_key) do
    "#{remove_messages(display)}#{num_key}"
  end

  defp remove_messages(display) do
    display
    |> String.replace("Welcome", "")
    |> String.replace("Error", "")
  end

  # add a single input after another
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

  # basic calculations (+-*/)
  #######################################################################
  defp calculate(operator, register, input) when operator == :add do
    # 0 for addition an subtraction, to not change value
    register + (parse_input(input) || 0)
  end

  defp calculate(operator, register, input) when operator == :sub do
    register - (parse_input(input) || 0)
  end

  defp calculate(operator, register, input) when operator == :mul do
    # 1 for multiplication an division, to not change value
    register * (parse_input(input) || 1)
  end

  defp calculate(operator, register, input) when operator == :div do
    register / (parse_input(input) || 1)
  end

  #######################################################################

  # error if operator doesnt match with the system
  defp calculate(operator, _, _) when operator not in @operator_keys do
    IO.puts("Invalid Operator: #{operator}")
    nil
  end
end
