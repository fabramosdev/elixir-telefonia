defmodule Assinante do
  @moduledoc """
    Módulo de assinante para cadastro de clientes `prepagos` e `pospagos`

    A função mais utilizada é a função `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  # def buscar_assinante(numero, key \\ :all), do: buscar(&(&1, &2))
  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)

  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)

  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)
  def assinantes(), do: read(:prepago) ++ read(:pospago)

  @doc """
  Função para cadastrar assinante prepago e pospagos

  ## Parametros da função

  - nome: parametro do nome do assinante
  - numero: parametro do numero do assinante
  - cpf: parametro do cpf do assinante
  - plano: parametros definidos => `:prepago` ou `:pospago`

  ## Exemplo

      iex> Assinante.cadastrar("Fabiano", "123", "123", :prepago)
      {:ok, "Assinante cadastrado com sucesso"}

  """
  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pega_plano(assinante)) ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, "Assinante cadastrado com sucesso"}

      _assinante ->
        {:error, "Assinante com este número cadastrado"}
    end
  end

  defp pega_plano(assinante) do
    case assinante.plano.__struct__ == Prepago do
      true -> :prepago
      false -> :pospago
    end
  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def deletar(numero) do
    assinante = buscar_assinante(numero)

    result_delete =
      assinantes()
      |> List.delete(assinante)
      |> :erlang.term_to_binary()
      |> write(assinante.plano)

    {result_delete, "Assinante #{assinante.nome} deletado"}
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, :enoent} ->
        {:error, "Arquivo inválido"}
    end
  end
end
