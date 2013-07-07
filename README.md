Thoughtware
===========

Media Sharing Community Site built on Ruby on Rails. It includes Background Jobs, Responsive Web Design and much more.


Requirements
------------
1. Ruby 2.0 and above. (http://www.ruby-lang.org/en/)
2. RubyGems. (http://rubygems.org/)
3. Rails. (http://rubyonrails.org/) 
4. Git. (http://lmgtfy.com/?q=how+to+install+git) 

Installation 
------------

* Choose a location to download thoughtware, by creating a local folder (you can name it anything you want, we like "tw")
	* Create the folder: mkdir tw 
	* Navigate into it: cd tw
	* Initialize the Repository: git init 
	* Download the latest stable version: git pull https://github.com/mindware/thoughtware.git
* As one would for any other rails application, you must install the database management system (DBMS) and create the database that is to be used by the application. You must also create the usernames with their respective passwords and grant the permissions for that user to the database. The configuration of the database is outside the scope of this guide. Please refer to your favorite Database's manual on how to do the aforementioned requirements. 
* If not using sqlLite as your DBMS, you must update the file database.yml in the ./config/ folder (./config/database.yml) accordingly. For more inforamtion, refer to: http://stackoverflow.com/questions/7304576/how-do-i-set-up-the-database-yml-file-in-rails
* You must create a file named ".env" in the root folder. in our case, ./tw/. This file will hold several global environment variables used by the application that are specific to your instance of the application. You may use your favorite editor in order to create this file (ie: vim ~/tw/.env), copy & paste, and customize the following values with your own:	

```

# Database configuration
# DEVELOPMENT DB
DB_USER_DEVELOPMENT="development_user" 		 # configure DB and customize this with your user
DB_PASSWORD_DEVELOPMENT="development_password" # configure DB and customize this with your password

# TEST DB
DB_USER_TEST="test_user"  		# configure DB and customize this with your user
DB_PASSWORD_TEST="test_password"  # configure DB and customize this with your password

# PRODUCTION DB
DB_USER_PRODUCTION="production_user"			# configure DB and customize this with your user
DB_PASSWORD_PRODUCTION="production_password"  # configure DB and customize this with your password

# Delayed Job Web Config User and Password
DELAYED_JOB_WEB_USER="thoughtware"			 # write the username you want for the web-interface used to see delayed job proccesses status on the server
DELAYED_JOB_WEB_PASSWORD="Your-Custom-Password-Here" # write the password you want for the web-interface used to see delayed job processes status on the server

```

* Use bundler to install all dependencies: bundle install
* Perform all migrations: rake db:migrate
* Finally, start the server: thin start
* And visit the app using a web-browser (the port can change depending on your configuration) http://localhost:3000/
* Access the delayed job interface here: http://localhost:3000/delayed_job/


2006-2013 &copy; Andrés Colón Pérez
