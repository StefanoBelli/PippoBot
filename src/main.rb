begin
	require 'rubygems'
	require 'bundler/setup'
	require 'telegram_bot'
rescue LoadError => err
	puts "Failed to load module: #{err}"
	exit 1
end

TOKEN="228855504:AAHh5fhFyEpel0WqTrYNCwVUKy3QeKumDcc"

class PippoBot
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
					 getArg=gotCmd.split(@PATTERN)
					 if getArg.length == 0 then
						reply.text = "PippoBot is still alive!"
					 end
				end
				reply.send_with(@BOT_INSTANCE)
			end
		end
	end
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
