# =========================================================================
# These are helper methods that will be available to your recipes.
# =========================================================================

##
# Writes out a database.yml from an ERB template.
#
def database_yml
  template = File.read(File.join(File.dirname(__FILE__), %w{templates database.yml.erb}))
  ERB.new(template).result(binding)
end

##
# Remotely connects to host and extracts datbase password from database.yml.
#
def find_database_passwords(env="production", var= :db_password)
  if cmd_if "-f #{shared_path}/config/database.yml"
    yaml_text = capture("cat #{shared_path}/config/database.yml")
    yaml = YAML.parse(ERB.new(yaml_text).result)
    set var.to_s, yaml[env]['password'].value if yaml[env]['password']
  end
end

##
# Sets a password variable via password prompt.

def prompt_db_password(var= :db_password, prompt="DB password for #{db_username}@#{db_database}: ")
  set(var.to_s) { pass_prompt(prompt) } unless exists?(var.to_s)
end


# =========================================================================
# These are the tasks that are available to help with deploying web apps,
# and specifically, Rails applications. You can have cap give you a summary
# of them with `cap -T'.
# =========================================================================

namespace :db do

  ##
  # with help from: 
  # http://wagglelabs.com/2008/09/disable-deploying-to-your-database-server-in-capistrano/
  #
  desc <<-DESC
    Creates an empty database and app user. This task will use your database \
    server role which is different than the database role created with a \
    default capistrano recipe.
    
    By default, capistrano wants to use the :db role to run rails migrations \
    and is not expected to be the actual database server. The :db_server \
    also needs `:no_release => true' so that it won't run the other \
    capistrano tasks such as "deploy:setup".
    
    To use this task, you need to set the :db_server variable like so:
    
      set :db_server, "dbserver.example.com", :no_release => true
      
    It will prompt by default for your root user's password and use that to \
    run the DDL commands. If you need to use another user, then the \
    :db_server_username variable like this:
    
      set :db_server_username, "johnnycakes"

    [WARNING] This command is probably not safe to run multiple times.
    
    Currently only MySQL is supported.
  DESC
  task :create, :roles => :db_server do
    resolve_passwords
    
    username = fetch(:db_server_username, "root")
    password = pass_prompt("#{username} db password on #{db_host}: ")
    
    ddls = [
      "create database #{db_database};",
      "use #{db_database}; create user '#{db_username}'@'localhost' identified by '#{db_password}';",
      "use #{db_database}; create user '#{db_username}'@'%' identified by '#{db_password}';",
      "use #{db_database}; grant all privileges on #{db_database}.* to '#{db_username}'@'localhost';",
      "use #{db_database}; grant all privileges on #{db_database}.* to '#{db_username}'@'%';",
    ]

    # stash :default_shell if we happen to be using rvm
    stash_default_shell = false
    if exists?(:default_shell)
      stash_default_shell = default_shell
      set :default_shell, "sh"
    end

    ddls.each do |d|
      run %{echo "#{d}" | mysql -u #{username} --password="#{password}"}
    end
    
    # return :default_shell to its stashed value
    if stash_default_shell
      set :default_shell, stash_default_shell
    end
  end
  
  desc <<-DESC
    Runs the rake db:seed task.
    
    You can set the rails environment and full path to rake by setting some \
    overriding variables. The defaults are:
    
      set :rake,      "rake"
      set :rails_env, "production"

    [WARNING] This command is probably not safe to run multiple times.
  DESC
  task :seed, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    
    run %{cd #{current_path} && #{rake} RAILS_ENV=#{rails_env} db:seed}
  end

  desc <<-DESC
    Prepares database.yml from template. If the file exists remotely, the \
    file is not created but is skipped over. To force the creation of a new \
    database.yml file, you can pass in the `force'' environment variable \
    like so:
    
      $ cap db:configure force=true
  DESC
  task :configure, :roles => :app, :except => { :no_release => true } do
    if cmd_if("-f #{shared_path}/config/database.yml") && ENV["force"].nil?
      inform "database.yml already exists, skipping"
    else
      ask_for_passwords
      run "mkdir -p #{shared_path}/config"
      put database_yml, "#{shared_path}/config/database.yml"
    end
  end

  desc <<-DESC
    [internal] Copies database.yml from shared_path into release_path.
  DESC
  task :cp_database_yml, :roles => :app, :except => { :no_release => true } do
   run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc <<-DESC
    Sets variables for database passwords. This task extracts database \
    passwords from the remote database.yml. You can add a "before" or \
    "after" hook on this task to set other password variables if your \
    deployment has multiple database connections. For example:
    
      after "db:resolve_passwords", "my:resolve_other_passwords"
  DESC
  task :resolve_passwords, :roles => :app, :except => { :no_release => true } do
    find_database_passwords("production", :db_password)
  end
  
  desc <<-DESC
    Asks for a database password and sets a variable. This will be used to \
    inject the value into the database.yml template. If multiple datbase \
    connections are used, then you can add a "before" or "after" hook on \
    this task. For example:
    
      after "db:ask_for_passwords", "my:ask_for_passwords"
  DESC
  task :ask_for_passwords, :except => { :no_release => true } do
    prompt_db_password(:db_password)
  end
end

after "deploy:setup", "db:configure"
after "deploy:update_code", "db:cp_database_yml"
