=begin
In this part, you can add commands!
just understand ruby!
The bot will do the rest!

1. define a function
2. return what it should say
3. update the HASH (Hash), this way:
 HASH={"typed_function_name",method(:methodName)}
=end

module Commands
=begin
   sayText: just repeat what is passed
            to the function
=end
  def Commands.sayText(what)
    return what
  end

=begin
   saluda: just "Saluda, Andonio!"
=end
  def Commands.saluda(what)
    return "Saluda, Andonio!"
  end
  
=begin
  Hash which contains
   (typed_func_name => method_name)
  needs to be updated every time
  you add a function
=end
  HASH={"sayText"=> method(:sayText), "saluda"=>method(:saluda)}
end
