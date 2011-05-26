Capistrano::Lastmile.load_named(:whenever) do

  # =========================================================================
  # These are default variables that will be set unless overriden.
  # =========================================================================

  lm_cset(:whenever_command)  { "bundle exec whenever" }


  require 'whenever/capistrano'
end
