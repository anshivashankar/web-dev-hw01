defmodule Practice.Palindrome do
  def palindrome(x) do
    charList = to_charlist(x)
    cond do
      charList == Enum.reverse(charList) -> true
      true -> false
    end
  end
end
