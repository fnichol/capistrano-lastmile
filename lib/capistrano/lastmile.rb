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
      recipes.flatten.each { |r| require "capistrano/lastmile/recipes/#{r}" }
    end

    def self.load_all!
      # load environment and extra recipes
      begin
        load_recipe!(extra_recipes)
      rescue NameError
        abort <<-MSG.gsub(/^ {8}/, '')

          ABORT: You cannot directly require "capistrano/lastmile" but rather
          require one of the deployment flavors under "capistrano/lastmile/*"
          to load in the appropriate recipes.

        MSG
      end

      # load default capistrano recipes
      load { load 'deploy' }

      # load in deployment and other task overrides
      load_recipe! %w{ruby/deploy_passenger deploy_extras}

      # load in local recipies
      Dir['vendor/plugins/*/recipes/*.rb'].each do |recipe|
        load { load recipe }
      end

      # load in project config/deploy.rb
      load { load 'config/deploy' } if File.exists?("config/deploy.rb")
    end
  end
end

Capistrano::Lastmile.load_all!
