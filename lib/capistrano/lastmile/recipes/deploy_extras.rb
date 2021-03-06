Capistrano::Lastmile.load_named(:deploy) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :deploy do

    desc <<-DESC
      Turn-key installation of the app.
    DESC
    task :turnkey do
      block_warn  <<-WARN
        This task will completely initialize your enviornment from nothing
        to a running application. If you want to update a running app, this
        is not the task for you.
      WARN
      unless Capistrano::CLI.debug_prompt("turn-key installation") =~ /^y/i
        abort "Aborting turn-key installation."
      end

      setup
      if fetch(:use_mysql, false)
        db.create
      end
      cold
    end

    desc <<-DESC
      Deploys and starts a `cold' application. This is useful if you have not \
      deployed your application before, or if your application is (for some \
      other reason) not currently running. It will deploy the code, run any \
      pending migrations, and then instead of invoking `deploy:restart', it \
      will invoke `deploy:start' to fire up the application servers.

      [NOTE] This overides the capistrano default by adding the "db:seed" \
      task, if the `db' recipe is loaded.
    DESC
    task :cold do
      update
      migrate
      if fetch(:use_db, false)
        db.seed
      end
      start
    end
  end
end
