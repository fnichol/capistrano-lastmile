Capistrano::Lastmile.load_named(:log) do

  # =========================================================================
  # These are helper methods that will be available to your recipes.
  # =========================================================================

  ##
  # Finds the editor to use.
  #
  def resolve_editor
    if ENV.has_key? "editor"
      editor = ENV["editor"]
    elsif ENV.has_key? "EDITOR"
      editor = ENV["EDITOR"]
    elsif ENV.has_key? "VISUAL"
      editor = ENV["VISUAL"]
    else
      editor = "vi"
    end
    
    editor
  end


  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  namespace :log do

    desc <<-DESC
      Tails the deployed application log.You can set the rails environment \
      by setting the :rails_env variable. The defaults are:
      
        set :rails_env, "production"
        set :tail,      "tail"
    DESC
    task :tail, :role => :app, :except => { :no_release => true } do
      tail = fetch(:tail, "tail")
      rails_env = fetch(:rails_env, "production")
      log_file = File.join(shared_path, "log", "#{rails_env}.log")

      stream("#{tail} -f #{log_file}")
    end
    
    desc <<-DESC
      View log files in local editor. You can set the rails environment and \
      tail command by setting variables. The defaults are:
      
        set :rails_env, "production"
        set :tail,      "tail"
        
      To override the default number of lines (500), you can pass in the `n' \
      environment variable like so:

        $ cap log:view n=900
        
      To override your EDITOR/VISUAL environment settings for your visual \
      editor, you can pass in the `editor' environment variable like so:
      
        $ cap log:view editor=nano
        
      Otherwise this task will try to resolve your editor in the following \
      order:
      
        1) use the `editor' environment override variable value
        2) use the `EDITOR' shell environment variable value
        3) use the `VISUAL' shell environment variable value
        4) use `vi' which should be in almost any PATH
    DESC
    task :view, :role => :app, :except => { :no_release => true } do
      tail = fetch(:tail, "tail")
      rails_env = fetch(:rails_env, "production")
      if ENV["n"].nil?
        num_lines = 500
      else
        num_lines = ENV["n"]
      end
      log_file = File.join(shared_path, "log", "#{rails_env}.log")

      require 'tempfile'
      tmp = Tempfile.open('w')
      logs = Hash.new { |h,k| h[k] = '' }
      
      run(%{#{tail} -n#{num_lines} #{log_file}}) do |channel, stream, data|
        logs[channel[:host]] << data
        break if stream == :err
      end
      
      logs.each do |host, log|
        tmp.write("--- #{host} ---\n\n")
        tmp.write(log + "\n")
      end
      tmp.flush

      exec "#{resolve_editor} #{tmp.path}" 
      tmp.close
    end
  end
end
