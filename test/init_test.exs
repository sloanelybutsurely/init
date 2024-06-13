defmodule InitTest do
  use ExUnit.Case
  doctest Init

  test "greets the world" do
    assert Init.hello() == :world
  end
end
