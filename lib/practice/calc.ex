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
    #|> hd
    #|> parse_float
    #|> :math.sqrt()

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end

  # Convert this expression to list of tuples with their atoms.
  def tag_tokens(chars) do
    chars
    |> Enum.map(&assign_atom/1)
    #|> IO.inspect
    #listOfTuples = [{:num, hd(chars)}, {:op, hd(chars)}]
    #IO.puts(Enum.join(Tuple.to_list(listOfTuples)))
    #chars
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
    #index = 0

    # get char
    # if it's a number;
    # add it to the output.
    # if it's an operation;
    # compare precedence to the op on the top of the opStack.
    # If it's greater, push it on to the opStack.
    # If it's lower, 
    # pop operators from opStack UNTIL
    # it's empty. OR
    # the op on opStack is strictly less than that of the current operator.
    
    
    convert_postfix_help(listOfTuples, output, opStack, -1)
    |>IO.inspect
    
  end

  def convert_postfix_help(listOfTuples, output, opStack, index) do
    index = index + 1
    cond do
      index == length(listOfTuples) ->
        output ++ Enum.reverse(opStack)
      true ->
        #index = index + 1
        tuple = Enum.at(listOfTuples, index)
        |> IO.inspect
        case tuple do
          # it's a number
          {:num, _} -> 
            #{output ++ [elem(tuple, 1)], opStack}
            #|> IO.inspect
            convert_postfix_help(listOfTuples, output ++ [elem(tuple, 1)], opStack, index)

          # its an operation, + or -
          {:op, operation} when operation in ["+", "-"] ->
            cond do
              # if its empty, then add on to the stack.
              Enum.empty?(opStack) ->
                #{output, opStack ++ [elem(tuple, 1)]}
                convert_postfix_help(listOfTuples, output, opStack ++ [elem(tuple, 1)], index)

              # here we know that we're either +/-, and encountered * or /
              List.last(opStack) in ["*", "/"] ->
                # pop the any that arent * or / and put it into output.
                #output = output ++ Enum.reverse(opStack)
                #[]
                #{output ++ Enum.reverse(opStack), []}
                convert_postfix_help(listOfTuples, output ++ Enum.reverse(opStack), [], index)
          
              # if its another + or -, add it on. (thats the only other option)
              List.last(opStack) in ["+", "-"] ->
                #{output, opStack ++ [elem(tuple, 1)]}
                convert_postfix_help(listOfTuples, output, opStack ++ [elem(tuple, 1)], index)

              true ->
                IO.puts("should never come here.")
                #{output, opStack}
                convert_postfix_help(listOfTuples, output, opStack, index)
            end

          # just add to stack for * and /, we have no higher order expressions, like parenthesis or exponents.
          {:op, operation} when operation in ["*", "/"] ->
            #{output, opStack ++ [elem(tuple, 1)]}
            convert_postfix_help(listOfTuples, output, opStack ++ [elem(tuple, 1)], index)

          _ -> 
            IO.puts("Should never come here.")
            #{output, opStack}
            convert_postfix_help(listOfTuples, output, opStack, index)
        end
    end
    #output ++ Enum.reverse(opStack)
  end

end
