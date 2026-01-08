# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

....
Project Setup & Database:
-bundle install = Install all required gems.
-rails db:create = Create the database.
- rails db:migrate = Run database migrations.
- rails db:seed = Seed the database with initial data (if seeds.rb is set up).
- rails s = Start the Rails server (default: http://localhost:3000).
- rails routes = List all routes.
- rails g scaffold ModelName field:type ... = Generate model, controller, views, and migration
- rails g model ModelName field:type ... = Generate a model and migration.
- rails g controller ControllerName actions = Generate a controller with actions.
- rails g migration MigrationName = Generate a new migration.
- rails db:rollback = Roll back the last migration.
....
Project Console: Work with database by command
- rails c = Open Rails console
- rails db = Open database console
- Project.create(name: "Bouengket FC Team") = create project by commnd
- project.save
- project.valid = check valid
- project.errors = find error
- project.errors.full-messages = find full error 
....
- bundle add tailwindcss-rails
- rails tailwindcss:install