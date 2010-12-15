# =========================================================================
# These are the tasks that are available to help with deploying web apps,
# and specifically, Rails applications. You can have cap give you a summary
# of them with `cap -T'.
# =========================================================================

##
# thanks to: 
# - http://errtheblog.com/posts/19-streaming-capistrano
# - http://snippets.dzone.com/posts/show/2485
#
desc <<-DESC
  Remote rails console. You can set the rails environment \
  by setting the :rails_env variable. The defaults are:
  
    set :rails_env, "production"
    set :ruby,      "ruby"
DESC
task :console, :role => :app, :except => { :no_release => true } do
  ruby = fetch(:rake, "ruby")
  rails_env = fetch(:rails_env, "production")

  input = ''
  run %{cd #{current_path} && RAILS_ENV=#{rails_env} #{ruby} script/console}, :once => true do |channel, stream, data|
    next if data.chomp == input.chomp || data.chomp == ''
    print data
    channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
  end
end
