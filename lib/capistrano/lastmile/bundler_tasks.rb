# =========================================================================
# These are the tasks that are available to help with deploying web apps,
# and specifically, Rails applications. You can have cap give you a summary
# of them with `cap -T'.
# =========================================================================

##
# thanks to:
# - http://kazjote.eu/2010/08/04/bundler-and-capistrano-the-right-way
# - http://blog.nicolasblanco.fr/2010/07/30/capistrano-task-for-bundler-1-0/
#
namespace :bundler do

  desc <<-DESC
    [internal] Creates a symlink to vendor/bundle to reuse bundled gems \
    across redeploys.
  DESC
  task :create_symlink, :roles => :app, :except => { :no_release => true } do
    set :bundle_dir, File.join(release_path, 'vendor', 'bundle')
    
    shared_dir = File.join(shared_path, 'bundle')
    run "rm -rf #{bundle_dir}"
    run "mkdir -p #{shared_dir} && ln -s #{shared_dir} #{bundle_dir}"
  end

  desc <<-DESC
    Calls `bundle install' in deployment mode. By default the `--without' \
    flag will be used to exclude the `development', `test', and `cucumber' \
    bundler groups in your Gemfile. To override the `--without' groups you \
    can set the :bundle_without variable to your groups in a space-seperated \
    list. The defaults are:
    
      set :bundle_without, "development test cucumber"
  DESC
  task :install, :roles => :app, :except => { :no_release => true } do
    without_groups = fetch(:bundle_without, 'development test cucumber')
    
    run %{cd #{release_path} && bundle install --deployment --without #{without_groups}}

    on_rollback do
      if previous_release
        run %{cd #{previous_release} && bundle install --deployment --without #{without_groups}}
      else
        logger.important "No previous release to rollback to, rollback of bundler:install skipped"
      end
    end
  end

  desc <<-DESC
    Prepares your servers for a bundler-enabled project. This calls both \
    `create_symlink' and `install'.
  DESC
  task :setup, :roles => :app, :except => { :no_release => true } do
    create_symlink
    install
  end
end

after "deploy:rollback:revision", "bundler:install"
after "deploy:update_code", "bundler:setup"
