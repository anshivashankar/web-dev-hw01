defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def double(x) do
    2 * x
  end

  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end

  def factor(x) do
    Practice.Factor.factor(x) # must be a List of numbers.
  end

  def palindrome(x) do
    Practice.Palindrome.palindrome(x)
    # TODO: Add a palindrome? function.
end
