module Capistrano
  module Lastmile

    def self.extra_recipes
      %w{
        helpers
        defaults
        rack/defaults
        rvm
        bundler
        ruby/database_yaml
        mysql
        ruby/config_yaml
        whenever
        mercurial
        git
        multistage
      }
    end

    def self.override_recipes
      %w{
        ruby/deploy_passenger
        deploy_extras
        rack/disable_railsisms
      }
    end
  end
end

require "capistrano/lastmile"
