module Capistrano
  module Lastmile

    def self.extra_recipes
      %w{
        helpers
        defaults
        rvm
        bundler
        database_yaml
        db 
        mysql
        config_yaml
        console
        log
        whenever
        mercurial
        git
        multistage
      }
    end
  end
end

require "capistrano/lastmile"
