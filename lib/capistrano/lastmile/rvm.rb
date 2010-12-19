Capistrano::Lastmile.load_named(:rvm) do

  # =========================================================================
  # These are default variables that will be set unless overriden.
  # =========================================================================

  lm_cset(:rvm_ruby_string) { "default@#{application}" }


  require 'rvm/capistrano'
end
