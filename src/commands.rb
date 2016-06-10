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
  require 'kat'
rescue LoadError => err
  $stderr.puts "--> Error while loading module: #{err}"
  exit 1
end

=begin
 Commands module:
  * contains commands functions
  * add them to the HASH (Hash) constant
    (see at the end of the module)
=end
module Commands
=begin
  Utils module:
   * contains various useful functions
=end
  module Utils
    #Utils.makeHTTPRequest : makes an HTTP request and returns response object
    def Utils.makeHTTPRequest(url)
      uriPath = URI.parse(url)
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
   mixcloud: returns detail about artist or mix
   on MixCloud (very simple)
   And make a rapid search :) 
=end
  def Commands.mixcloud(what)
    searchType = String.new
    parsedBody = Hash.new
    splitted = String(what).split(" ")
    mixcloudapi="http://api.mixcloud.com/"
    return "--> Not enough arguments" if splitted.length == 0

    if splitted.length >= 1 then
      case splitted[0]
      when "details"
        mixname=String.new
        mixcloudapi+=splitted[1]+"/" if splitted.length == 2
        if splitted.length > 3 then
          splitted[2..splitted.length].each do |i|
            mixname+=i+" "
          end
          mixname[mixname.length-1]=""
          mixname=mixname.downcase.gsub!(" ","-")
          mixcloudapi+=splitted[1].to_s+"/"+mixname.to_s+"/"
        elsif splitted.length == 3 then
          mixname=splitted[2]
          mixname=mixname.downcase
          mixcloudapi+=splitted[1].to_s+"/"+mixname.to_s+"/"
        end
        
        return "--> You should specify <artist> [mix]" if splitted.length == 1
      when "search"
        if splitted[1] == "cloudcast" or splitted[1] == "user" or splitted[1] == "tag" then
          searchType=splitted[1].to_s
        else
          return "--> Non-valid search filter!"
        end

        searchQuery = String.new
        if splitted.length > 3 then
          splitted[2..splitted.length-1].each do |i|
            searchQuery+=i+" "
          end
          searchQuery[searchQuery.length-1]=""
          searchQuery=searchQuery.downcase.gsub!(" ","+")
          mixcloudapi=sprintf mixcloudapi+"search/?q=%s&type=%s",searchQuery, searchType
        elsif splitted.length == 3 then
          searchQuery=splitted[2]
          searchQuery=searchQuery.downcase
          mixcloudapi+= sprintf "search/?q=%s&type=%s", searchQuery, searchType
        else
          return "--> Not enough arguments"
        end
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
      return "--> Oops! Error during request!\n--> Maybe artist/mix doesn't exist!"
    end

    formattedText=String.new
    case splitted[0]
    when "details"
      if splitted.length == 2 then        
      #artist only
        formattedText = sprintf "Artist: %s\nArtist Followers: %d\nArtist Following: %d\nArtist Bio: %s\nArtist Cloudcasts: %d\n\
Artist Mixcloud URL: %s\n",parsedBody["username"], parsedBody["follower_count"], parsedBody["following_count"], parsedBody["biog"],
                              parsedBody["cloudcast_count"], parsedBody["url"]
      elsif splitted.length > 2 then
        #artist and mix
        formattedText = sprintf "Mix: %s\nPlayed: %d times\nFavourites: %d\nRepost: %d times\nMix URL: %s\n",
                                parsedBody["name"],parsedBody["play_count"],parsedBody["favorite_count"], parsedBody["repost_count"],
                                parsedBody["url"]
        formattedText+=sprintf "Mix description: %s\n",parsedBody["description"].to_s if parsedBody["description"] == nil or
           not parsedBody["description"].empty?
      end
    when "search"
      formattedText=String.new
      #need to get array
      arr = parsedBody["data"]
      if arr == nil or arr.empty? then
        return "--> This search produced NO result!"
      end

      arr.each_with_index do |elem,index|
        formattedText+= sprintf "==> %s\nURL: %s\n", elem["name"], elem["url"]
        formattedText+= sprintf "Username: %s\n", elem["username"] if searchType == "user"

        if searchType == "cloudcast" then
          userInfo = elem["user"]
          formattedText+= sprintf "Uploader: %s\nUploader URL: %s\nUploader Name: %s\nPlayed: %d time(s)\nFav: %d\nRepost: %d time(s)\n",
                                  userInfo["username"], userInfo["url"], userInfo["name"],
                                  elem["play_count"],elem["favorite_count"],elem["repost_count"]
          if index >= 7 then
            return formattedText+"\n===> TOO MUCH OUTPUT! <==== (8 result max.)"
          end
        end

        if index >= 30 then
          return formattedText+"\n===> TOO MUCH OUTPUT! <=== (31 result max.)"
        end
      end

      return formattedText
    end
  end

=begin
  Searches on Kickass Torrents
   * need to specify <category|nocat> <query>
=end
  def Commands.kat(what)
    what=what.to_s
    category=String.new
    searchQuery=String.new
    
    if what.length == 0 then
      return "--> Not enough arguments: [category] <query>"
    end

    what=what.split(" ")
    
    if what.length == 1 then
      return "--> Not enough arguments: ([category]) <query>"
    elsif what.length > 1 then
      category=what[0]
      what[1..what.length].each do |elem|
        searchQuery+=elem + " "
      end
    end

    searchQuery[searchQuery.length-1]=""

    category == "nocat" ? category=nil : category=category
    
    katsearch = Kat.search(searchQuery, {:category => category })

    formattedText = String.new
    searched=katsearch.search 

    begin
      searched[0..4].each do |elem|
        formattedText += sprintf "===> %s\n* Age: %s\n* Seeds: %d\n* Leeches: %d\n* Magnet: %s\n* Torrent DL: %s\n* Files: %d\n* URL: kat.cr%s\n",
                        elem["title".to_sym],elem["age".to_sym], elem["seeds".to_sym], elem["leeches".to_sym],
                        elem["magnet".to_sym],elem["download".to_sym],elem["files".to_sym],elem["path".to_sym]
      end
    rescue NoMethodError
      $stderr.puts "==> Something went wrong!!"
      return "==> Oops! Check query or category! / If not then something went wrong!"
    end
    
    return formattedText
  end
  
=begin
  Hash which contains
   (typed_func_name => method(:method_name))
  needs to be updated every time
  you add a function
=end
  HASH={
    "sayText"   =>  method(:sayText),
    "saluda"    =>  method(:saluda),
    "mixcloud"  =>  method(:mixcloud),
    "katsearch" =>  method(:kat)
  }
end
