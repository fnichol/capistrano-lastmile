Capistrano::Lastmile.load_named(:defaults) do

  lm_cset :rails_env,         "production"

  # default-enabled recipes
  lm_cset :use_database_yaml, true
  lm_cset :use_db,            true
  lm_cset :use_console,       true
  lm_cset :use_log,           true
  lm_cset :use_mysql,         true

  # default-disabled recipes
  lm_cset :use_config_yaml,   false
  lm_cset :use_whenever,      false
end
