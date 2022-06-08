defmodule PrepagoTest do
  use ExUnit.Case

  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "funçoes de ligação" do
    test "deve fazer uma ligação" do
      assinante = Assinante.cadastrar("Fabiano", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35"}
    end
  end
end
