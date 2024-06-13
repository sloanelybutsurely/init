defmodule Echo do
  def ping(pid, value, delay) do
    Process.sleep(delay)
    send(pid, value)
  end
end

defmodule InitTest do
  use ExUnit.Case, async: true

  describe "when passed a module-function-arguments tuple" do
    test "it runs to completion before other children of a Supervisor" do
      children = [
        Supervisor.child_spec({Init, {Echo, :ping, [self(), :foo, 20]}}, id: {Init, 1}),
        Supervisor.child_spec({Init, {Echo, :ping, [self(), :bar, 10]}}, id: {Init, 2})
      ]

      start_supervised!(%{
        id: Supervisor,
        start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
      })

      assert_receive :foo
      assert_receive :bar
    end
  end

  describe "when passed a 0-arity anonymous function" do
    test "it runs to completion before other children of a Supervisor" do
      self = self()

      children = [
        Supervisor.child_spec(
          {Init,
           fn ->
             Process.sleep(20)
             send(self, :foo)
           end},
          id: {Init, 1}
        ),
        Supervisor.child_spec(
          {Init,
           fn ->
             Process.sleep(10)
             send(self, :bar)
           end},
          id: {Init, 2}
        )
      ]

      start_supervised!(%{
        id: Supervisor,
        start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
      })

      assert_receive :foo
      assert_receive :bar
    end
  end
end
