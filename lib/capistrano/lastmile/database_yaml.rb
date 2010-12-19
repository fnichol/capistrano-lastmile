Capistrano::Lastmile.load_named(:database_yaml) do

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
  # @param [String] env  rails environment to fetch password from
  # @param [Symbol] var  capistrano variable that password will be assigned to
  def find_database_passwords(env="production", var= :db_password)
    if cmd_if "-f #{shared_path}/config/database.yml"
      yaml_text = capture("cat #{shared_path}/config/database.yml")
      yaml = YAML.parse(ERB.new(yaml_text).result)
      set var.to_s, yaml[env]['password'].value if yaml[env]['password']
    end
  end

  ##
  # Sets a password variable via password prompt.
  #
  # @param [Symbol] var  capistrano variable that will be assigned to
  # @param [String] prompt  message to be displayed then asking for db password
  def prompt_db_password(var= :db_password, prompt="DB password for #{db_username}@#{db_database}: ")
    set(var.to_s) { pass_prompt(prompt) } unless exists?(var.to_s)
  end


  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :db do

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
end