Capistrano::Lastmile.load_named(:hoptoad) do

  require 'hoptoad_notifier/capistrano'

  ##
  # Modified from:
  # https://github.com/thoughtbot/hoptoad_notifier/blob/master/lib/hoptoad_notifier/capistrano.rb
  #
  # This patch runs the rake hoptoad:deploy command on the target server rather
  # then running locally where the necessary configuration may not exist.
  namespace :deploy do
    desc "Notify Hoptoad of the deployment"
    task :notify_hoptoad, :except => { :no_release => true } do
      rails_env = fetch(:hoptoad_env, fetch(:rails_env, "production"))
      local_user = ENV['USER'] || ENV['USERNAME']
      executable = RUBY_PLATFORM.downcase.include?('mswin') ? fetch(:rake, 'rake.bat') : fetch(:rake, 'rake')
      notify_command = "cd #{release_path} && #{executable} hoptoad:deploy RAILS_ENV=#{rails_env} TO=#{rails_env} REVISION=#{current_revision} REPO=#{repository} USER=#{local_user}"
      notify_command << " DRY_RUN=true" if dry_run
      notify_command << " API_KEY=#{ENV['API_KEY']}" if ENV['API_KEY']
      puts "Notifying Hoptoad of Deploy (#{notify_command})"
      run notify_command, :once => true
      puts "Hoptoad Notification Complete."
    end
  end
end
