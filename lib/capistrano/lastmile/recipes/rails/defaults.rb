Capistrano::Lastmile.load_named(:defaults) do

  lm_cset :rails_env,       "production"

  # default-disabled recipes
  lm_cset :use_config_yaml, false
  lm_cset :use_whenever,    false
end
