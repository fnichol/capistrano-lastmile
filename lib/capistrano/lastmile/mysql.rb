Capistrano::Lastmile.load_named(:mysql) do

  # =========================================================================
  # These are default variables that will be set unless overriden.
  # =========================================================================

  if exists?(:deploy_server)
    role(:db_server, :no_release => true) { deploy_server }
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
  end
end
