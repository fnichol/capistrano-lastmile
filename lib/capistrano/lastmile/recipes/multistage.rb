Capistrano::Lastmile.load_named(:multistage) do

  begin
    lm_cset :stages,        %w{staging production}
    lm_cset :default_stage, "staging"

    require 'capistrano/ext/multistage'

    # =========================================================================
    # These are the tasks that are available to help with deploying web apps,
    # and specifically, Rails applications. You can have cap give you a summary
    # of them with `cap -T'.
    # =========================================================================

    desc <<-DESC
      Lists all valid deployment environments.
    DESC
    task :stages, :roles => :app, :except => { :no_release => true } do
      puts "\nValid stages are:\n\n"
      fetch(:stages, []).each { |s| puts "  #{s}" }
      puts
    end

  rescue LoadError
    # capistrano-ext isn't loaded so don't worry about it
    unset :stages
    unset :default_stage
  end
end
