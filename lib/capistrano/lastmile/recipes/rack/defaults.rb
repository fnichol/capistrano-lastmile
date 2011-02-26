Capistrano::Lastmile.load_named(:defaults) do

  lm_cset :rack_env,          "production"

  # default-enabled recipes
  lm_cset :use_disable_railsisms, true

  # default-disabled recipes
  lm_cset :use_database_yaml, false
  lm_cset :use_mysql,         false
  lm_cset :use_config_yaml,   false
  lm_cset :use_whenever,      false
end
