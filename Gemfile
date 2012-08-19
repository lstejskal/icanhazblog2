source 'http://rubygems.org'

gem 'rails', '~> 3.2.8'

gem 'mysql2', '~> 0.3.11'

# password encryption
gem 'bcrypt-ruby', :require => 'bcrypt' 

# pagination for mongoid
# PS: 3.0 doesn't work with mongodb yet
gem 'will_paginate', '~> 2.3'

# template handler
gem 'haml', '~> 3.1'

# css extension
gem 'sass', '~> 3.1'

# syntax highlighting
gem 'coderay', '~> 0.9'

# captcha in comment forms
gem 'recaptcha', '~> 0.3', :require => 'recaptcha/rails'

# exception reporting
gem 'exception_notification', '~> 2.4', :require => 'exception_notifier'

# Gems used only for assets and not required in production by default
group :assets do  
  gem 'sass-rails', '~> 3.2.5'  
  gem 'coffee-rails', '~> 3.2.2'  
  gem 'uglifier', '~> 1.2.7' 
end  
  
gem 'jquery-rails', '~> 2.1.1'

# debugging is allowed by default in development environment
# temporarily omitted, can't install linecache19
#group :development do
#  gem 'ruby-debug19' 
#end

# some test utilities are used in rails console  during development
group :development, :test do
  gem 'minitest'
  gem 'shoulda'
  gem 'turn'
  gem 'factory_girl'
  gem 'fakeweb'
  gem 'mocha'
end
