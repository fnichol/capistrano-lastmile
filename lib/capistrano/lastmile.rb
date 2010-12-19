module Capistrano
  module Lastmile

    def self.load(&block)
      ::Capistrano::Configuration.instance(:must_exist).load(&block)
    end

    def self.load_named(name, &block)
      load { load(&block) unless disabled?(name) }
    end
  end
end
