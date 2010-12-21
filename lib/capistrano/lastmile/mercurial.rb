Capistrano::Lastmile.load_named(:mercurial) do

  # =========================================================================
  # These are the tasks that are available to help with deploying web apps,
  # and specifically, Rails applications. You can have cap give you a summary
  # of them with `cap -T'.
  # =========================================================================

  on :load do
    # only load mercurial tasks if that's our scm
    if exists?(:scm) && scm == :mercurial
      namespace :hg do

        desc <<-DESC
          Lists all current mercurial tags.
        DESC
        task :tags, :roles => :app, :except => { :no_release => true } do
          tags = %x{hg tags}.map { |l| l.sub(/^([^\s]+)\s+.*$/, '\1').chomp }
          puts "Mercurial tags are:"
          tags.each { |t| puts t }
        end

        desc <<-DESC
          Lists all current mercurial branches.
        DESC
        task :branches, :roles => :app, :except => { :no_release => true } do
          tags = %x{hg branches}.map { |l| l.sub(/^([^\s]+)\s+.*$/, '\1').chomp }
          puts "Mercurial branches are:"
          tags.each { |t| puts t }
        end
      end
    end
  end
end
