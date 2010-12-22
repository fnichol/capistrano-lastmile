Capistrano::Lastmile.load_named(:defaults) do

  lm_cset(:application) do
    abort <<-ABORT.gsub(/^ {6}/, '')
      Please specify the name of your application. For exaple:

        set :application, 'bunny_slippers'

    ABORT
  end

  lm_cset :scm,             :git
  lm_cset :user,            "deploy"
  lm_cset :use_sudo,        false
  lm_cset :keep_releases,   10
  lm_cset :bundle_without,  [:development, :test, :test_mac]
  lm_cset :rails_env,       "production"

  lm_cset(:deploy_to) { "/srv/#{application}" }

  # default-disabled recipes
  lm_cset :use_config_yaml, false
  lm_cset :use_whenever,    false
end
