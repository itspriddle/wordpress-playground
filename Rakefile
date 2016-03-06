class String
  def strip_heredoc
    min = scan(/^[ \t]*(?=\S)/).min
    indent = (min && min.size) || 0
    gsub(/^[ \t]{#{indent}}/, '')
  end
end

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

def wp_cli_config
  @wp_cli_config ||= Class.new do
    attr_reader :user, :password, :email, :port, :url, :title, :dbname,
      :dbuser, :dbhost

    def initialize
      @user     = ENV.fetch("WP_USERNAME")    { ENV["USER"] }
      @password = ENV.fetch("WP_PASSWORD")    { "passw0rd" }
      @email    = ENV.fetch("WP_EMAIL")       { "#{ENV["USER"]}@#{`hostname`.chomp}" }
      @port     = ENV.fetch("WP_SERVER_PORT") { 9000 }
      @url      = ENV.fetch("WP_URL")         { "http://localhost:#{port}" }
      @title    = ENV.fetch("WP_TITLE")       { "WordPress Playground" }
      @dbname   = ENV.fetch("WP_DBNAME")      { "wpplayground" }
      @dbuser   = ENV.fetch("WP_DBUSER")      { "root" }
      @dbhost   = ENV.fetch("WP_DBHOST")      { "localhost" }
    end

    def to_yaml
      <<-YML.strip_heredoc
        path: "public"

        server:
          docroot: public
          port: #{wp_cli_config.port}

        core config:
          dbname: #{wp_cli_config.dbname}
          dbuser: #{wp_cli_config.dbuser}
          dbhost: #{wp_cli_config.dbhost}
          extra-php: |
            define('WP_HOME',    '#{wp_cli_config.url}');
            define('WP_SITEURL', '#{wp_cli_config.url}');

        core install:
          admin_user: #{wp_cli_config.user}
          admin_password: #{wp_cli_config.password}
          admin_email: #{wp_cli_config.email}
          url: #{wp_cli_config.url}
          title: #{wp_cli_config.title}
      YML
    end
  end.new
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
  desc <<-DESC.strip_heredoc
  Create wp-cli.local.yml

  This task creates a basic `wp-cli.local.yml` file with default settings for
  some wp-cli commands.

  The following ENV variables can be passed:

    WP_USERNAME    - Username for WP-Admin account
                     Default is: $USER
    WP_PASSWORD    - Password for WP-Admin account
                     Default is: passw0rd
    WP_EMAIL       - Email for WP-Admin account
                     Default is: $USER@$HOSTNAME
    WP_SERVER_PORT - Port used to run PHP webserver server
                     Default is: 9000
    WP_URL         - WordPress blog URL (make sure to include port)
                     Default is: http://localhost:9000
    WP_TITLE       - WordPress blog title
                     Default is: WordPress Playground
    WP_DBNAME      - MySQL database name
                     Default is: wpplayground
    WP_DBUSER      - MySQL database name
                     Default is: root
    WP_DBHOST      - MySQL database host (usually localhost)
                     Default is: localhost
  DESC
  task :"wp-cli" do
    File.write "wp-cli.local.yml", wp_cli_config.to_yaml
  end

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
