require 'bundler/capistrano'

set :application, "wedding"
set :repository,  "."
set :deploy_via, :copy

set :scm, :none
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "chrisandshonagh.com"                          # Your HTTP server, Apache/etc
role :app, "chrisandshonagh.com"                          # This may be the same as your `Web` server
role :db,  "chrisandshonagh.com", :primary => true        # This is where Rails migrations will run

set :deploy_to, "/home/p847647r/apps/wedding"
set :user, "p847647r"
set :use_sudo, false

set :default_environment, {
    'PATH' =>  "/usr/local/rvm/gems/ruby-1.9.2-p0/bin:/usr/local/rvm/gems/ruby-1.9.2-p0@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p0/bin:/usr/local/rvm/bin:/usr/kerberos/bin:/usr/lib/courier-imap/bin:/usr/local/bin:/bin:/usr/bin:/home/p847647r/bin",
    'RUBY_VERSION' => 'ruby-1.9.2-p0',
    'GEM_HOME' => '/home/p847647r/.gems',
    'GEM_PATH' => '/home/p847847r/.gems:/usr/local/rvm/gems/ruby-1.9.2-p0',
    'BUNDLE_PATH' => '/home/p847647r/.gems'
}

# exclude dev/test gems from production(!)
task :production do
  set :bundle_without, [:development, :test]
end

# fixup platform in Gemfile
before "bundle:install" do
  run "sed -i 's/bcrypt-ruby (\\([^0-9]*[0-9.]*\\).*)/bcrypt-ruby (\\1)/' #{current_release}/Gemfile.lock"
  run "sed -i 's/thin (\\([^0-9]*[0-9.]*\\).*)/thin (\\1)/' #{current_release}/Gemfile.lock"
end

# make cap play nicely with thin
namespace :deploy do
  desc "Restart the Thin processes on the app server."
  thin = "cd #{current_path} && bundle exec thin %s -d -C config/thin.yml"
  task :restart do
    run thin % 'restart'
  end
  desc "Start the Thin processes on the app server."
  task :start do
    run thin % 'start'
  end
  desc "Stop the Thin processes on the app server."
  task :stop do
   run thin % 'stop'
  end
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


 
