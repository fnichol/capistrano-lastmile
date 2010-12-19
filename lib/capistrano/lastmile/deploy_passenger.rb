Capistrano::Lastmile.load_named(:passenger) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :deploy do

    desc <<-DESC
      Starts your app (passenger). This just calls `restart' since \
      passenger only requires to touch a file.
    DESC
    task :start, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_release}/tmp/restart.txt"
    end

    desc <<-DESC
      Stops your app (passenger). This task is a no-op, i.e. it does nothing.
    DESC
    task :stop, :roles => :app, :except => { :no_release => true } do
      # Do nothing.
    end

    desc <<-DESC
      Restarts your app (passenger). All that is needed is to touch \
      tmp/restart.txt for passenger to pick it up.
    DESC
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end
end
