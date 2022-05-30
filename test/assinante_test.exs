defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "Testes responsáveis para cadastro de assinantes" do
    test "deve criar uma conta prepago" do
      assert Assinante.cadastrar("Fabiano", "123", "123") ==
               {:ok, "Assinante cadastrado com sucesso"}
    end

    test "deve retornar erro para assinante já cadastrado" do
      Assinante.cadastrar("Fabiano", "123", "123")

      assert Assinante.cadastrar("Fabiano", "123", "123") ==
               {:error, "Assinante com este número cadastrado"}
    end
  end

  describe "Testes responsáveis pela busca de assinantes" do
    test "deve buscar assinante pospago" do
      Assinante.cadastrar("Fabiano", "123", "123", :pospago)

      assert Assinante.buscar_assinante("123", :pospago) == %Assinante{
               cpf: "123",
               nome: "Fabiano",
               numero: "123",
               plano: :pospago
             }
    end

    test "deve buscar assinante prepago" do
      Assinante.cadastrar("Fabiano", "123", "123", :prepago)

      assert Assinante.buscar_assinante("123", :prepago) == %Assinante{
               cpf: "123",
               nome: "Fabiano",
               numero: "123",
               plano: :prepago
             }
    end
  end
end
