Capistrano::Lastmile.load_named(:whenever) do

  # =========================================================================
  # These are default variables that will be set unless overriden.
  # =========================================================================

  lm_cset(:whenever_command)    { "bundle exec whenever" }
  lm_cset(:whenever_identifier) { "#{application}_#{deploy_env}" }


  require 'whenever/capistrano'
end
