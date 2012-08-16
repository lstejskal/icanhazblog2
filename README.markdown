# I Can Haz Blog 2?! #

## Description

Icanhazblog is a blog application running on MySQL and Rails ~> 3.2.

*Why u no use MongoDB? (Like in icanhazblog.)* MongoDB is (was?) cooler that MySQL. But let's face it, it's an overkill for a simple blog application. Among other things it takes way too much disc space for a such a small database. The MongoDB code is still be available (but not maintained) in `icanhazblog` repository.

## Installation

* Install required gems:
`bundle install`

* Set up database:
`config/database.yml.example -> database.yml`

* Check if everything it working:
`rake test`

* Put initial data into database:
`rake db:setup`

* If you want to see some dummy blog posts in the application for the start, run:
`rake db:generate_random_articles`

* Set up API keys for [reCAPTCHA](https://github.com/ambethia/recaptcha)
`config/initializers/recaptcha.rb.example -> recaptcha.rb`

* Set up your secret token:
`config/initializers/secret_token.rb.example -> secret_token.rb`

* (Optional) set up your tracking code for Google Analytics, etc.
`app/assets/javascripts/tracking_code.js.example -> tracking_code.js`

* Set up production environment
`config/environments/production.rb.example -> production.rb`

* Run +rails server+ and go to +http://localhost:3000/+

## Author

2010-2012 Lukas Stejskal
