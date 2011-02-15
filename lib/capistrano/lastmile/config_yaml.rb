Capistrano::Lastmile.load_named(:config_yaml) do

  # =========================================================================
  # These are helper methods that will be available to your recipes.
  # =========================================================================

  ##
  # Finds the appropriate config.yml.erb. There are only 2 possible locations
  # that the erb file can exist:
  #
  # * in `config/templates/config.yml.erb`
  # * in `vendor/plugins/*/recipes/templates/config.yml.erb`
  #
  # The first match in the above list will win, meaning that
  # `config/templates/config.yml.erb` overrides the `vendor/.../` version.
  def find_config_yml_file
    config_version = File.join(%w{config templates config.yml.erb})
    vendor_version = File.join(
      %w{vendor plugins * recipes templates config.yml.erb})

    if File.exists?(config_version)
      logger.debug "Using #{config_version} as config template"
      config_version
    elsif ! Dir[vendor_version].empty?
      c = vendor_version.first
      logger.debug "Using #{c} as config template"
      c
    else
      abort <<-ABORT.gsub(/^ {8}/, '')

        Config file config.yml.erb cannot be found in the project. You must
        create this file in one of the following locations:

          #{config_version}
          #{vendor_version}

      ABORT
    end
  end

  ##
  # Writes out a config.yml from an ERB template.
  #
  def config_yml
    template = File.read(find_config_yml_file)
    ERB.new(template).result(binding)
  end


  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  # ensure that a config.yml.erb template exists in the project
  on :load do
    find_config_yml_file
  end

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
