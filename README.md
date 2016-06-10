# PippoBot
Pippo is a Telegram Bot, written in Ruby. Base bot: [eljojo/telegram_bot](https://github.com/eljojo/telegram_bot)

### How to run

 _Requires Ruby-Bundler_

 * Inside PippoBot directory just type
 ~~~
 $ bundle install
 ~~~

 * then, run src/main.rb
 ~~~
 $ ruby src/main.rb
 ~~~

 The bundler will install: *telegram_bot* and *json* gems

### Commands

 * Useless commands
	~~~
	pippo saluda #just says 'Saluda, Andonio!'
	~~~

	~~~
	pippo sayText some_text #repeats some_text
	~~~

 * Mixcloud
	~~~
	pippo mixcloud search [tag|user|cloudcast] <query> #searches query using a filter
	~~~

	~~~
	pippo mixcloud details artist #searches details about "artist"
	~~~

	~~~
	pippo mixcloud details artist mix #searches details about "artist/mix"
	~~~
 
 * KAT - Kickass Torrent Search
   Shows only first 5 results 
   ~~~
	pippo katsearch nocat silicon valley #searches for Silicon valley without filter
	~~~

	~~~
	pippo katsearch tv silicon valley #seaches for silicon valley using 'tv' category filter
	~~~
