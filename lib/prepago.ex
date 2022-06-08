defmodule Prepago do
  defstruct creditos: 10, recargas: []
  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= 10 -> {:ok, "A chamada custou #{custo}"}
      true -> {:error, "créditos insuficientes"}
    end
  end
end
