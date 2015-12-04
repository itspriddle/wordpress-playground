# WordPress Playground

A little playground for toying with WordPress on OS X.

## Prerequisites:

* wp-cli: `brew install itspriddle/brew/wp-cli`
* mysql: `brew install mysql`

On OS X you need to configure `/etc/php.ini` to know about Homebrew's MySQL:

    sudo cp -n /etc/php.ini.default /etc/php.ini
    sudo sed -i '.bak' 's,default_socket[[:space:]]*=$,default_socket = /tmp/mysql.sock,' /etc/php.ini

## Usage

Install:

    wp core config
    wp db create
    wp core install

Run server:

    wp server

View in browser:

    open http://localhost:9000/
