Capistrano::Lastmile.load_named(:git) do
  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  on :load do
    # only load git tasks if that's our scm
    if exists?(:scm) && scm == :git
      namespace :git do

        desc <<-DESC
          Lists all current git tags.
        DESC
        task :tags, :roles => :app, :except => { :no_release => true } do
          tags = %x{git tag}.split("\n").reverse
          puts "Git tags are:"
          puts "HEAD"
          tags.each { |t| puts t }
        end

        desc <<-DESC
          Lists all current git branches.
        DESC
        task :branches, :roles => :app, :except => { :no_release => true } do
          tags = %x{git branch --no-color}.map { |l| l.sub(/^[ *]+/, '').chomp }
          puts "Git branches are:"
          tags.each { |t| puts t }
        end
      end
    end
  end
end
