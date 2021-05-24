require "fileutils"
require "shellwords"

def add_template_source_path
    source_paths.unshift(File.dirname(__FILE__))
end

def add_gems
  gem_group :development, :test do
    gem "standardrb"
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'faker'
  end

  gem_group :development do
    gem "fuubar"
    gem "guard"
    gem 'guard-rspec'
    gem 'guard-livereload', '~> 2.5', require: false
  end

  gem_group :test do
    gem "rexml" # Added to fix error until selenium-webdriver updated to v.4
    gem "simplecov", require: false
  end

end

def set_application_name
  environment "config.application_name = Rails.application.class.module_parent_name"
end

def add_static
  generate "controller welcome home"

  route "root to: 'welcome#home'"
end

def copy_templates
  copy_file "Guardfile"
  copy_file ".rspec", force: true
  copy_file ".standard.yml"
  copy_file ".simplecov"
  copy_file "app/assets/stylesheets/dr.css"
  copy_file "app/views/layouts/application.html.erb", force: true

  directory "config", force: true
  directory "spec", force: true

end

def stop_spring
  run "spring stop"
end

def database_setup
  rails_command("db:create")
  rails_command("db:migrate")
end

# Main setup
add_template_source_path

add_gems

after_bundle do
  set_application_name
  stop_spring
  copy_templates
  add_static
  database_setup

  say
  say "Rails Article app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "  cd #{app_name}"
end
