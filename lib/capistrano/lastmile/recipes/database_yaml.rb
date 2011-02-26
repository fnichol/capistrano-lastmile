Capistrano::Lastmile.load_named(:database_yaml) do

  # =========================================================================
  # These are helper methods that will be available to your recipes.
  # =========================================================================

  ##
  # Finds the appropriate database.yml.erb. There are only 2 possible
  # locations that the erb file can exist:
  #
  # * in `config/templates/database.yml.erb`
  # * in `vendor/plugins/*/recipes/templates/database.yml.erb`
  # * a default version in this gem
  #
  # The first match in the above list will win, meaning that
  # `config/templates/database.yml.erb` overrides the `vendor/.../` version.
  def find_database_yml_file
    config_version = File.join(%w{config templates database.yml.erb})
    vendor_version = File.join(
      %w{vendor plugins * recipes templates database.yml.erb})

    if File.exists?(config_version)
      logger.debug "Using #{config_version} as database template"
      config_version
    elsif ! Dir[vendor_version].empty?
      c = Dir[vendor_version].first
      logger.debug "Using #{c} as database template"
      c
    else
      d = File.join(File.dirname(__FILE__), %w{templates database.yml.erb})
      logger.debug "Using default database.yml.erb from gem"
      d
    end
  end

  ##
  # Writes out a database.yml from an ERB template.
  #
  def database_yml
    template = File.read(File.expand_path(find_database_yml_file))
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
  # These are default variables that will be set unless overriden.
  # =========================================================================

  lm_cset(:db_username) do
    abort <<-ABORT.gsub(/^ {8}/, '')
      Please specify the name of your dabatase application user. You need
      this to be less than 16 characters for MySQL. For exaple:

        set :db_username, 'bunny_prd'

    ABORT
  end

  lm_cset :db_adapter,  "mysql"
  lm_cset :db_host,     "localhost"
  lm_cset(:db_database) { "#{application}_#{deploy_env}" }


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
      [internal]
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
      [internal]
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
