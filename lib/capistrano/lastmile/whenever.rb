Capistrano::Lastmile.load_named(:whenever) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :cron do

    desc <<-DESC
      Updates all crontab entries for this application.
    DESC
    task :update, :roles => :db, :only => { :primary => true } do
      run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
    end

    desc <<-DESC
      Empties all crontab entries for this application.
    DESC
    task :clear, :roles => :db, :only => { :primary => true } do
      run "cd #{release_path} && bundle exec whenever --clear-crontab #{application}"
    end
  end

  after "deploy:symlink", "cron:update"
end
