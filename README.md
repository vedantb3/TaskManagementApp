# TaskManagementApp
TaskManagementApp is a Ruby on Rails application designed for managing tasks and their deadlines.

### Ruby Version
ruby 3.0.0

### Rails Version
rails 7.1.3

### System Dependencies
Ensure you have Node.js and Yarn installed. You can install them using Homebrew:
brew install node
brew install yarn

### Configuration

git clone https://github.com/vedantb3/TaskManagementApp.git
cd TaskManagementApp
bundle install
yarn install


### Database Setup
TaskManagementApp uses PostgreSQL as the database. Ensure you have PostgreSQL installed and running locally.

Create the database and run migrations:

- rails db:create
- rails db:migrate

### How to run the test suite

bundle exec rspec

### How to start app server

bundle exec rails s