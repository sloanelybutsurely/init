defmodule Init do
  @moduledoc """
  Run a function synchronously as part of a `Supervisor`
  """
  use GenServer, restart: :transient

  def start_link(arg, opts \\ []) do
    GenServer.start_link(__MODULE__, mfa!(arg), opts)
  end

  @impl true
  def init({mod, fun, args}) do
    apply(mod, fun, args)
    :ignore
  end

  defp mfa!({_m, _f, _a} = mfa), do: mfa
  defp mfa!(fun) when is_function(fun, 0), do: {Kernel, :apply, [fun, []]}
end
