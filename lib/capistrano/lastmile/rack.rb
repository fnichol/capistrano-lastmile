module Capistrano
  module Lastmile

    def self.extra_recipes
      %w{
        helpers
        defaults
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
  end
end

require "capistrano/lastmile"
