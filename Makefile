.PHONY: install default clean

# Non-default themes that have been installed
INSTALLED_THEMES=`wp theme list --field=name 2> /dev/null | grep -v -E '^twenty(fif|four|thir)teen$$'`

# Non-default plugins that have been installed
INSTALLED_PLUGINS=`wp plugin list --field=name 2> /dev/null | grep -v -E '^akismet|hello$$'`

default:
	@echo 'Install:'
	@echo
	@echo '  make install'
	@echo
	@echo 'Uninstall:'
	@echo
	@echo '  make clean'

install:
	wp core config
	wp db create
	wp core install

clean:
	for theme in $(INSTALLED_THEMES); do wp theme uninstall $$theme; done
	for plugin in $(INSTALLED_PLUGINS); do wp plugin uninstall $$plugin; done
	wp db drop --yes
	rm -f public/wp-config.php
	rm -rf public/wp-content/uploads
