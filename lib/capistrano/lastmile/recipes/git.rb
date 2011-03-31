Capistrano::Lastmile.load_named(:git) do

  on :load do
    # only load git tasks if that's our scm
    if exists?(:scm) && scm == :git

      def all_tags
        @all_tags ||= %x{git tag}.split("\n").concat(["HEAD"]).reverse
      end

      def all_branches
        @all_branches ||= %x{git branch --no-color}.split("\n").map do |l|
          l.sub(/^[ *]+/, '').chomp
        end
      end
 
      set :branch do
        if all_tags.size == 1
          default_tag = all_tags[0]   # get "HEAD"
        else
          default_tag = all_tags[1]   # use latest tag that is not "HEAD"
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
          inform "Using git tag: [#{tag}]"
        else
          inform "Using git branch: [#{tag}]"
        end
        tag
      end


      # ======================================================================
      # These are the tasks that are available to help with deploying web
      # apps, and specifically, Rails applications. You can have cap give
      # you a summary of them with `cap -T'.
      # =========================================================================

      namespace :git do

        desc <<-DESC
          Lists all current git tags.
        DESC
        task :tags, :roles => :app, :except => { :no_release => true } do
          puts "\nGit tags are:\n\n"
          all_tags.each { |t| puts "  #{t}" }
          puts
        end

        desc <<-DESC
          Lists all current git branches.
        DESC
        task :branches, :roles => :app, :except => { :no_release => true } do
          puts "\nGit branches are:\n\n"
          all_branches.each { |t| puts "  #{t}" }
          puts
        end
      end
    end
  end
end
