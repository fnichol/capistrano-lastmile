Capistrano::Lastmile.load_named(:rvm) do

  lm_cset(:rvm_ruby_string) { "default@#{application}" }

  require 'rvm/capistrano'
end
