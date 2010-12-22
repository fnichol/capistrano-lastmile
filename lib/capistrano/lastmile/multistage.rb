Capistrano::Lastmile.load_named(:multistage) do

  begin
    lm_cset :stages, %w{staging production}

    require 'capistrano/ext/multistage'
  rescue LoadError
    # capistrano-ext isn't loaded so don't worry about it
    unset :stages
  end
end
