defmodule SydneyTest do
  use ExUnit.Case
  doctest Sydney

  test "greets the world" do
    assert Sydney.hello() == :world
  end
end
