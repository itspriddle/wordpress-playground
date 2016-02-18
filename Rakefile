def default_themes
  %W(twentythirteen twentyfourteen twentyfifteen twentysixteen).freeze
end

def default_plugins
  %W(akismet hello).freeze
end

def run(cmd)
  `#{cmd}`.chomp.tap do |out|
    puts cmd
    puts out
  end
end

def wp(cmd)
  run "wp #{cmd}"
end

def list(type)
  wp("#{type.to_s.chop} list --field=name 2> /dev/null").strip.split("\n").reject do |name|
    send(:"default_#{type}").include? name
  end
end

desc "Completely clean plugins, themes, configs, db and uploads"
task clean: %i(clean:plugins clean:themes clean:db clean:config clean:uploads)

namespace :clean do
  desc "Uninstall non-default plugins"
  task :plugins do
    list(:plugins).each do |name|
      wp "plugin uninstall --deactivate #{name}"
    end
  end

  desc "Uninstall non-default themes"
  task :themes do
    # We need to switch to a default theme in order to delete a custom one
    # that has been activated
    wp "theme activate twentysixteen"

    list(:themes).each do |name|
      wp "theme delete #{name}"
    end
  end

  desc "Clear WP database"
  task :db do
    run "wp db drop --yes"
  end

  desc "Delete uploaded files"
  task :uploads do
    rm_rf "public/wp-content/uploads"
  end

  desc "Delete wp-config.php"
  task :config do
    rm_rf "public/wp-config.php"
  end
end

desc "Install WordPress"
task install: %i(install:config install:db install:core)

namespace :install do
  desc "Create wp-config.php"
  task :config do
    wp "core config"
  end

  desc "Setup DB"
  task :db do
    wp "db create"
  end

  desc "Install WP core"
  task :core do
    wp "core install"
  end
end

desc "Reinstall WordPress"
task reinstall: %i(clean install)
