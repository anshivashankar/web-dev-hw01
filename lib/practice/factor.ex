defmodule Practice.Factor do
  def factor(x) do
    factor_help(x, x, [])
  end

  # returns a list of numbers.
  defp factor_help(x, numberAt, factors) do
    cond do
      x == 1 ->
        factors
      numberAt == 1 -> 
        [ x | factors ]
      rem(x, numberAt) == 0 && is_prime?(numberAt) ->
        newNum = div(x, numberAt)
        factor_help(newNum, newNum - 1, [numberAt | factors])
      true ->
        factor_help(x, numberAt - 1, factors)
    end
  end

  defp is_prime?(numberAt) do
    is_prime_help(numberAt, numberAt-1)
  end

  defp is_prime_help(numberAt, checkNum) do
    cond do
      checkNum == 1 -> true
      true ->
        case rem(numberAt, checkNum) do
          0 -> false
          _ -> is_prime_help(numberAt, checkNum - 1)
        end
    end
  end
      
    
end
