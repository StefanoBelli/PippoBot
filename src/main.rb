begin
  require 'rubygems'
  require 'bundler/setup'
  require 'telegram_bot'
  require './commands.rb'
rescue LoadError => err
  puts "Failed to load module: #{err}"
  exit 1
end

TOKEN="228855504:AAHh5fhFyEpel0WqTrYNCwVUKy3QeKumDcc"

class PippoBot
  include Commands
  attr_reader :BOT_INSTANCE
  attr_reader :PATTERN

  def initialize(logger=Logger.new(STDOUT))
    @BOT_INSTANCE=TelegramBot.new(logger: logger, timeout: 10, token: TOKEN)
    @PATTERN=/^pippo */
  end

  def messageHandler
    @BOT_INSTANCE.get_updates(fail_silently: false) do |msg|
      msg.reply do |reply|
	gotCmd=msg.get_command_for(@BOT_INSTANCE)
        if gotCmd.match(@PATTERN) then
          messageParser reply,gotCmd
        end
      end
    end
  end

  def messageParser(reply,command)
    if command.match(@PATTERN)
      args = command.split(@PATTERN)
      if args.length == 0 then
        reply.text="PippoBot still alive!"
        reply.send_with(@BOT_INSTANCE)
      elsif args.length >= 1 then
        args = args[1].split(" ",2)
        Commands::HASH.each_key do |k|
         if args[0] == k then
             retval = Commands::HASH[k].call(args[1])
             reply.text=retval
             reply.send_with(@BOT_INSTANCE)
         end
        end
      end
    end
  end

  private :messageParser
end

begin
  if ARGV.length == 1 and ARGV.length < 2 then
    puts "--> Logging to: #{ARGV[0]}"
    p = PippoBot.new(Logger.new(ARGV[0]))
  elsif ARGV.length > 1 then
    puts "--> Too much arguments! :/"
    exit 1
  else
    puts "--> You can specify a logfile location, instead of stdout!"
    p = PippoBot.new
  end
  p.messageHandler
rescue Interrupt
  puts "Byebye :)"
  exit 0
end
