# A huge thanks to youthtree-capistrano for the loading and disabling pattern.
# https://github.com/YouthTree/youthtree-capistrano/
module Capistrano
  module Lastmile

    def self.load(&block)
      ::Capistrano::Configuration.instance(:must_exist).load(&block)
    end

    def self.load_named(name, &block)
      load { load(&block) unless disabled?(name) }
    end

    def self.load_recipe!(*recipes)
      recipes.flatten.each { |r| require "capistrano/lastmile/#{r}" }
    end

    def self.load_all!
      # load environment and extra recipes
      load_recipe! %w{helpers defaults rvm bundler database_yaml db 
        mysql config_yaml console log whenever mercurial git multistage}

      # load default capistrano recipes
      load { load 'deploy' }

      # load in deployment and other task overrides
      load_recipe! %w{deploy_passenger deploy_extras}
    end
  end
end

Capistrano::Lastmile.load_all!
