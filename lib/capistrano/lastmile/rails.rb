module Capistrano
  module Lastmile

    def self.extra_recipes
      %w{
        helpers
        defaults
        rails/defaults
        rvm
        bundler
        ruby/database_yaml
        rails/db
        mysql
        ruby/config_yaml
        rails/console
        rails/log
        whenever
        ruby/hoptoad
        mercurial
        git
        multistage
      }
    end

    def self.override_recipes
      %w{
        ruby/deploy_passenger
        deploy_extras
      }
    end
  end
end

require "capistrano/lastmile"
