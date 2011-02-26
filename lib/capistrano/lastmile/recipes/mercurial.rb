Capistrano::Lastmile.load_named(:mercurial) do

  on :load do
    # only load mercurial tasks if that's our scm
    if exists?(:scm) && scm == :mercurial

      def all_tags
        @all_tags ||= %x{hg tags}.map do |line|
          line.sub(/^([^\s]+)\s+.*$/, '\1').chomp
        end
      end

      def all_branches
        @all_branches ||= %x{hg branches}.map do |line|
          line.sub(/^([^\s]+)\s+.*$/, '\1').chomp
        end
      end

      set :branch do
        if all_tags.size == 1
          default_tag = all_tags[0]   # use "tip"
        else
          default_tag = all_tags[1]   # use latest tag that is not "tip"
        end

        if ENV['tag']
          if (all_tags | all_branches).include?(ENV['tag'])
           tag = ENV['tag'] 
          else
            block_warn <<-MSG.sub(/^ {14}/, '')
              Invalid tag/branch: #{ENV['tag']}. Current tag values are:

              #{all_tags.inspect}

              Current branch values are:

              #{branches.inspect}
            MSG
            abort
          end
        else
          tag = default_tag
        end

        if all_tags.include?(tag)
          inform "Using mercurial tag: [#{tag}]"
        else
          inform "Using mercurial branch: [#{tag}]"
        end
        tag
      end
  

      # ======================================================================
      # These are the tasks that are available to help with deploying web 
      # apps, and specifically, Rails applications. You can have cap give 
      # you a summary of them with `cap -T'.
      # ======================================================================

      namespace :hg do

        desc <<-DESC
          Lists all current mercurial tags.
        DESC
        task :tags, :roles => :app, :except => { :no_release => true } do
          puts "\nMercurial tags are:\n\n"
          all_tags.each { |t| puts "  #{t}" }
          puts
        end

        desc <<-DESC
          Lists all current mercurial branches.
        DESC
        task :branches, :roles => :app, :except => { :no_release => true } do
          puts "\nMercurial branches are:\n\n"
          all_branches.each { |t| puts "  #{t}" }
          puts
        end
      end
    end
  end
end
