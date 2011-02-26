Capistrano::Lastmile.load_named(:console) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  ##
  # thanks to:
  # - http://errtheblog.com/posts/19-streaming-capistrano
  # - http://snippets.dzone.com/posts/show/2485
  desc <<-DESC
    Remote rails console. You can set the rails environment \
    by setting the :rails_env variable. The defaults are:

      set :rails_env, "production"
      set :ruby,      "ruby"
  DESC
  task :console, :role => :app, :except => { :no_release => true } do
    ruby = fetch(:ruby, "ruby")
    rails_env = fetch(:rails_env, "production")

    input = ''

    if cmd_if("-e #{current_path}/script/console")
      script = "script/console"
    elsif cmd_if("-e #{current_path}/script/rails")
      script = "script/rails console"
    else
      abort "Version of rails could not be determined."
    end

    run %{cd #{current_path} && #{ruby} #{script} #{rails_env}},
        :once => true do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      if data =~ /^[^ -]+-[^ ]+ :\d{3} (>|\?)/
        channel.send_data(input = $stdin.gets)
      end
    end
  end
end
