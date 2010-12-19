module Capistrano
  module Lastmile

    def self.load(&block)
      ::Capistrano::Configuration.instance(:must_exist).load(&block)
    end

    def self.load_named(name, &block)
      load { load(&block) unless disabled?(name) }
    end

    def self.load_recipe!(*recipes)
      puts "wtf: #{recipes.inspect}"
      recipes.flatten.each { |r| require "capistrano/lastmile/#{r}" }
    end
  end
end

Capistrano::Lastmile.load_recipe! "helpers"
