defmodule Calculator do
  use Debug, debug: false

  defstruct display: "Welcome",
            register: 0.0,
            operator: :idle,
            input: "",
            state: :input

  def init() do
    {:ok, %__MODULE__{}}
  end

  def key(
        %__MODULE__{state: :input, input: input, display: display} = cal,
        num_key
      )
      when num_key in ~w/0 1 2 3 4 5 6 7 8 9 ./ do
    {:ok,
     %{
       cal
       | input: "#{String.replace(input, "+", "")}#{num_key}",
         display: "#{display |> String.replace("Welcome", "")}#{num_key}"
     }}
  end

  def key(
        %__MODULE__{state: :input, input: input, display: display} = cal,
        operator_key
      )
      when operator_key == "+" do
    {:ok,
     %{
       cal
       | input: "+",
         register: parse_input(input),
         operator: :add,
         display: "#{display |> String.replace("Welcome", "")} + "
     }}
  end

  def key(
        %__MODULE__{
          state: :input,
          operator: :add,
          register: register,
          input: input
        } = cal,
        operator_key
      )
      when operator_key == "=" do
    result = register + parse_input(input)

    {:ok,
     %{
       cal
       | input: "=",
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
end
