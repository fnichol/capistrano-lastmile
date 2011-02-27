Capistrano::Lastmile.load_named(:defaults) do

  # default-enabled recipes
  lm_cset :use_deploy_stubs,      true
  lm_cset :use_disable_railsisms, true

  # default-disabled recipes
  lm_cset :use_mysql,         false
  lm_cset :use_whenever,      false
end
