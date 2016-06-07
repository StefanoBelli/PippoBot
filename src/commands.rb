=begin
In this part, you can add commands!
just understand ruby!
The bot will do the rest!

1. define a function
2. return what it should say
3. update the HASH (Hash), this way:
 HASH={"typed_function_name",method(:methodName)}
=end

begin
  require 'rubygems'
  require 'net/http'
  require 'json'
  require 'uri'
rescue LoadError => err
  puts "--> Error while loading module: #{err}"
  exit 1
end

module Commands
=begin
  Utils module:
   * contains various useful functions
=end
  module Utils
    #Utils.makeHTTPRequest : makes an HTTP request and returns response
    def Utils.makeHTTPRequest(url)
      uriPath = URI.parse(url+'/')
      puts uriPath.to_s
      req=Net::HTTP::Get.new(uriPath.to_s)
      Net::HTTP.start(uriPath.host, uriPath.port) do |http|
        response=http.request(req)
        case response
        when Net::HTTPSuccess then
          return response
        else
          return nil
        end
      end
    end
  end
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
   searchMixcloud: returns detail about artist or mix
   on MixCloud (very simple)
=end
  def Commands.mixcloud(what)
    parsedBody = Hash.new
    splitted = String(what).split(" ")
    mixcloudapi="http://api.mixcloud.com/"
    return "--> Not enough arguments" if splitted.length == 0

    if splitted.length >= 1 then
      case splitted[0]
      when "details"
        mixcloudapi+=splitted[1] if splitted.length == 2
        if splitted.length >= 3
          mixname=String.new
          splitted[2..splitted.length].each do |i|
            mixname+=i+" "
          end

          mixname[mixname.length-1]=""
          mixname=mixname.downcase.gsub!(" ","-")
          
          mixcloudapi+=splitted[1]+'/'+mixname
        end
        
        return "--> You should specify <artist> [mix]" if splitted.length == 1
      else
        return "--> Non-valid option!"
      end
    end
    
    if (resp=Utils.makeHTTPRequest(mixcloudapi)) != nil then
      body = resp.body
      if not body.empty? then
        parsedBody = JSON.parse(body)
      else
        return "--> Oops! Got empty body! Can't be parsed!"
      end
    else
      return "--> Oops! Error during request!"
    end

    formattedText=String.new
    case splitted[0]
    when "details"
      if splitted.length == 2
        #artist only
      elsif splitted.length > 2
        #artist and mix
      end
    end
    
  end
  
=begin
  Hash which contains
   (typed_func_name => method(:method_name))
  needs to be updated every time
  you add a function
=end
  HASH={
    "sayText"=> method(:sayText),
    "saluda"=>method(:saluda),
    "mixcloud" => method(:mixcloud)
  }
end
