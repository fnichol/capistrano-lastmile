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

  lm_cset(:deploy_to)       { "/srv/#{application}" }

  role(:web)                  { deploy_server if exists?(:deploy_server) }
  role(:app)                  { deploy_server if exists?(:deploy_server) }
  role(:db, :primary => true) { deploy_server if exists?(:deploy_server) }

  # common default-enabled recipes
  lm_cset :use_rvm,           true
  lm_cset :use_bundler,       true
  lm_cset :use_mercurial,     true
  lm_cset :use_git,           true
  lm_cset :use_multistage,    true
end
