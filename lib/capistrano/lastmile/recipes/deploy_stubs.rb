Capistrano::Lastmile.load_named(:deploy_stubs) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps.
  # You can have cap give you a summary of them with `cap -T'.
  # =========================================================================

  namespace :deploy do

    desc <<-DESC
      [internal] No-op to disable default task.
    DESC
    task :start, :roles => :app, :except => { :no_release => true } do
    end

    desc <<-DESC
      [internal] No-op to disable default task.
    DESC
    task :stop, :roles => :app, :except => { :no_release => true } do
    end

    desc <<-DESC
      [internal] No-op to disable default task.
    DESC
    task :restart, :roles => :app, :except => { :no_release => true } do
    end
  end
end
