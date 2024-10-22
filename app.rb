#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
#require 'haml'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something wrong'
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@hairstylist = params[:hairstylist]
	@color = params[:color]

	hh = { :username => 'Введите имя',
			:phone => 'Введите телефон',
			:date_time => 'Введите дату и время',
			:hairstylist => 'Выберите парикмахера'}

	hh.each do |key, value|
		if params[key] == "" || params[key] == "none"
			@error = hh[key]
			return erb :visit
		end 
	end

	#@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	#if @error != ''
	#	return erb :visit
	#end

	
	f = File.open 'C:/Projects/Ruby_Lesson_22/public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@date_time}, Hairstylist: #{@hairstylist}, Color: #{@color}\n"
	f.close

	erb :visit_result
end


post '/visit_result' do
	erb :visit
end

post '/contacts' do
	@user_email = params[:user_email]
	@text = params[:user_text]

	if @user_email == ""
		@error = "Введите e-mail"
		return erb :contacts
	end

	#Pony.mail(:to => "efita41@gmail.com", :from => "#{@user_email}", :body => "#{@text}")

	#haml :contact

	@title = 'Благодарим за ваше обращение!'
	@message = "Мы свяжемся с вами по электронной почте #{@user_email}"

	f = File.open 'C:/Projects/Ruby_Lesson_22/public/contacts.txt', 'a'
	f.write "User e-mail: #{@user_email}, Text: #{@text}\n"
	f.close

	erb :message
end

