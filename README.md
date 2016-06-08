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
	pippo mixcloud search _[tag|user|cloudcast]_ _<query>_ #searches query using a filter
	~~~

	~~~
	pippo mixcloud details _artist_ #searches details about "artist"
	~~~

	~~~
	pippo mixcloud details _artist_ _mix_ #searches details about "artist/mix"
	~~~
