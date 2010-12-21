Capistrano::Lastmile.load_named(:git) do

  on :load do
    # only load git tasks if that's our scm
    if exists?(:scm) && scm == :git

      def all_tags
        @all_tags ||= %x{git tag}.split("\n").concat(["HEAD"]).reverse
      end

      def all_branches
        @all_branches ||= %x{git branch --no-color}.map { |l| l.sub(/^[ *]+/, '').chomp }
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
