defmodule Calculator do
  use GenServer

  @number_keys ~w/0 1 2 3 4 5 6 7 8 9 ./
  @operator_keys ~w|+ * / d r -|
  @enter_key "="

  defstruct display: "Welcome!"

  ## API

  @doc """
  Starts a new calculator process.
  Returns `{:ok, pid}` or an error.
  """
  def start_link(name  \\ Calculator), do: GenServer.start_link(__MODULE__, %__MODULE__{}, name: name)

  @doc """
  Stops the server/calculator with the given `pid`
  """
  def stop(pid), do: GenServer.stop(pid, :normal)

  @doc """
  Get the current display as a string
  """
  def display(pid), do: GenServer.call(pid, :display)

  @doc """
  Press a key
  """
  def press_key(pid, ch) when is_binary(ch) do
    GenServer.cast(pid, {:press_key, ch})
  end

  ## GenServer implementation

  @impl true
  def init(calculator), do: {:ok, calculator}

  ## GenServer Callbacks

  @impl true
  def handle_call(:display, _, calculator) do
    {:reply, calculator.display, calculator}
  end

  @impl true
  def handle_cast({:press_key, ch}, calculator) when ch in @number_keys do
    {:noreply, %{calculator | display: remove_messages(calculator).display <> ch}}
  end

  @impl true
  def handle_cast({:press_key, ch}, calculator) when ch in @operator_keys do
    {f, _} = Float.parse(calculator.display)
    {:noreply, %{calculator | display: "#{f}#{ch}"}}
  end

  @impl true
  def handle_cast({:press_key, @enter_key}, calculator) do
    result =
      Float.parse(calculator.display)
      |> calculate()

    {:noreply, %{calculator | display: "#{result}"}}
  end

  @impl true
  def handle_cast({:press_key, _ignored_key}, calculator) do
    {:noreply, calculator}
  end

  ## Helpers
  defp remove_messages(calculator) do
    %{calculator | display: String.replace(calculator.display, "Welcome!", "")}
  end

  defp calculate({a, "+" <> b_str}), do: calculation(a, b_str, fn ^a, b -> a + b end)

  defp calculate({a, "-" <> b_str}), do: calculation(a, b_str, fn ^a, b -> a - b end)

  defp calculate({a, "/" <> b_str}), do: calculation(a, b_str, fn ^a, b -> a / b end)

  defp calculate({a, "*" <> b_str}), do: calculation(a, b_str, fn ^a, b -> a * b end)

  defp calculate({a, "d" <> b_str}),
    do: calculation(a, b_str, fn ^a, b -> div(floor(a), floor(b)) end)

  defp calculate({a, "r" <> b_str}),
    do: calculation(a, b_str, fn ^a, b -> rem(floor(a), floor(b)) end)

  defp calculation(a, b_str, fun) do
    {b, ""} = Float.parse(b_str)
    fun.(a, b)
  end
end
