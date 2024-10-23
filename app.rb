#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
#require 'pony'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" (	
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"Name"	TEXT, 
			"Phone"	TEXT, 
			"DateStamp" TEXT, 
			"Barber" TEXT, 
			"Color"	TEXT
			)'
	db.close
end

def save_form_data_to_database
	db = get_db
	db.execute 'INSERT INTO Users (name, phone, datestamp, barber, color)
	VALUES (?, ?, ?, ?, ?)',
		[@username, @phone, @date_time, @hairstylist, @color]
	db.close
end

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

	
	#f = File.open 'public/users.txt', 'a'
	#f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@date_time}, Hairstylist: #{@hairstylist}, Color: #{@color}\n"
	#f.close
	
	save_form_data_to_database
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

	#Pony.mail({
	 # :to => 'efita41@gmail.ru',
	 #:subject   => 'BarberShop new contact',
	 # :body    => "#{@user_email}, #{@text}",
	 # :via    => :smtp,
	 # :via_options => {
	 # :address        => 'smtp.gmail.com',
	 # :port           => '587',
	 # :user_name      => 'efita-syrova@gmail.com',
	 # :password       => 'Efremova905',
	 # :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
	 # :domain         => 'gmail.com' # the HELO domain provided by the client to the server
  	#}
 #})

	

	@title = 'Благодарим за ваше обращение!'
	@message = "Мы свяжемся с вами по электронной почте #{@user_email}"

	f = File.open 'public/contacts.txt', 'a'
	f.write "User e-mail: #{@user_email}, Text: #{@text}\n"
	f.close

	erb :message
end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by Id desc'
	
	erb :showusers
end

