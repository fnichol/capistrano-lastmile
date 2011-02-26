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
        mercurial
        git
        multistage
      }
    end
  end
end

require "capistrano/lastmile"
