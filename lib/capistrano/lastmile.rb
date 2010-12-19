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
      load_recipe! %w{helpers defaults rvm bundler}
      load { load 'deploy' }
    end
  end
end

Capistrano::Lastmile.load_all!
