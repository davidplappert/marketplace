source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use webpacker to manage application-like JavaScript in Rails
gem 'webpacker', '~> 3.5.5'
# Use devise for authentication
gem 'devise'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'mongoid', 									'~> 7.0'
gem 'mongoid-autoinc',					'~> 6.0'
gem 'mongoid-history',					'~> 0.8'
# gem 'mongoid_userstamp',				'~> 0.4'. # Errors out with before_filter in ActionController

gem 'aasm',                     '~> 4.8'
gem 'aws-sdk',                  '~> 3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'money-rails',							'~> 1.13'
gem 'pundit',                   '~> 2.0'

gem 'sassc',                    '~> 1.12'
gem 'slim',                     '~> 3.0'

# gem 'symmetric-encryption',     '~> 3.6'

gem 'virtus'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails', 						'~> 3.8'
	gem 'factory_bot_rails', 			'~> 4'
  gem 'shoulda-matchers',             '~> 3'
  gem 'mongoid-rspec',                '~> 4'
  gem 'pry'
  gem 'database_cleaner',       '~> 1.7'
end

group :development do

	# Use Capistrano for deployment
	gem 'capistrano-rails',       '~>1.1.6'

    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
