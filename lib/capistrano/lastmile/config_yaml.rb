Capistrano::Lastmile.load_named(:config_yaml) do

  # =========================================================================
  # These are helper methods that will be available to your recipes.
  # =========================================================================

  ##
  # Writes out a config.yml from an ERB template.
  #
  def config_yml
    template = File.read(File.join(File.dirname(__FILE__), 
      %w{templates config.yml.erb}))
    ERB.new(template).result(binding)
  end


  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :config do

    desc <<-DESC
      Prepares config.yml from template. If the file exists remotely, the \
      file is not created but is skipped over. To force the creation of a new \
      config.yml file, you can pass in the `force'' environment variable \
      like so:
      
        $ cap config:configure force=true
    DESC
    task :configure, :roles => :app, :except => { :no_release => true } do
      if cmd_if("-f #{shared_path}/config/config.yml") && ENV["force"].nil?
        inform "config.yml already exists, skipping"
      else
        run "mkdir -p #{shared_path}/config"
        put config_yml, "#{shared_path}/config/config.yml"
      end
    end

    desc <<-DESC
      [internal] Copies config.yml from shared_path into release_path.
    DESC
    task :cp_config_yml, :roles => :app, :except => { :no_release => true } do
     run "cp #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    end
  end

  after "deploy:setup", "config:configure"
  after "deploy:update_code", "config:cp_config_yml"
end
