Capistrano::Lastmile.load_named(:disable_railsisms) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :deploy do

    desc <<-DESC
      [internal] No-op for rack applications.
    DESC
    task :migrate, :roles => :db, :only => { :primary => true } do
    end

    desc <<-DESC
      [internal] No-op for rack applications.
    DESC
    task :migrations do
    end
  end
end
