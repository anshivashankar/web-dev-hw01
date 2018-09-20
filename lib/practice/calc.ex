defmodule Practice.Calc do
  def parse_float(text) do
    response = Float.parse(text)
    case response do
      :error -> text
      _ -> elem(response, 0)
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.

    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> convert_postfix
    |> tag_tokens
    |> stack_calculate([])

  end

  # Convert this expression to list of tuples with their atoms.
  def tag_tokens(chars) do
    chars
    |> Enum.map(&assign_atom/1)
  end

  def assign_atom(char) do
    possibleNumber = parse_float(char)
    cond do 
      is_number(possibleNumber) -> {:num, char}
      true -> {:op, possibleNumber}
    end
  end

  def convert_postfix(listOfTuples) do
    opStack = []
    output = []
    
    convert_postfix_help(listOfTuples, output, opStack, -1)
    
  end

  def convert_postfix_help(listOfTuples, output, opStack, index) do
    index = index + 1
    cond do
      index == length(listOfTuples) ->
        output ++ Enum.reverse(opStack)
      true ->
        tuple = Enum.at(listOfTuples, index)
        case tuple do
          # it's a number
          {:num, _} -> 
            convert_postfix_help(listOfTuples, output ++ [elem(tuple, 1)], opStack, index)

          # its an operation, + or -
          {:op, operation} when operation in ["+", "-"] ->
            cond do
              # if its empty, then add on to the stack.
              Enum.empty?(opStack) ->
                convert_postfix_help(listOfTuples, output, opStack ++ [elem(tuple, 1)], index)

              # here we know that we're either +/-, and encountered * or /
              List.last(opStack) in ["*", "/"] ->
                # pop until we've reached + or - and next up is a * or /.
                convert_postfix_help(listOfTuples, output ++ Enum.reverse(opStack), [elem(tuple, 1)], index)
          
              # if its another + or -, use left-to-right precedence order.
              List.last(opStack) in ["+", "-"] ->
                convert_postfix_help(listOfTuples, output ++ [List.last(opStack)], List.replace_at(opStack, length(opStack) - 1, elem(tuple, 1)), index)

              true ->
                IO.puts("should never come here.")
                convert_postfix_help(listOfTuples, output, opStack, index)
            end

          # just add to stack for * and /, we have no higher order expressions, like parenthesis or exponents.
          {:op, operation} when operation in ["*", "/"] ->
            cond do
              # if its * or /, use left-to-right precedence order.
              List.last(opStack) in ["*", "/"] ->
                convert_postfix_help(listOfTuples, output ++ [List.last(opStack)], List.replace_at(opStack, length(opStack) - 1, elem(tuple, 1)), index)
              true ->
                convert_postfix_help(listOfTuples, output, opStack ++ [elem(tuple, 1)], index)
            end
          _ -> 
            IO.puts("Should never come here.")
            convert_postfix_help(listOfTuples, output, opStack, index)
        end
    end
  end

  # tagged_output is the Arithmatic Expression. result is a list of numbers.
  def stack_calculate(tagged_output, result) do
    cond do
      Enum.empty?(tagged_output) -> 
        hd(result)
      true -> 
        case hd(tagged_output) do
          {:num, number} -> stack_calculate(tl(tagged_output), [parse_float(number) | result])
          {:op, operator} -> stack_calculate(tl(tagged_output), eval(result, operator))
          _ -> 
            IO.puts("This shouldn't happen. Should be tagged appropriately.")
            stack_calculate(tl(tagged_output), result)
        end
    end
  end

  # should be only 2 operands in result. Otherwise, algorithm went wrong.
  def eval(result, operator) do
    first = Enum.at(result, 0)
    second = Enum.at(result, 1)
    popped = tl(tl(result))
    case operator do
      "+" -> [second + first | popped]
      "-" -> [second - first | popped]
      "*" -> [second * first | popped]
      "/" -> [second / first | popped]
    end
  end

end
