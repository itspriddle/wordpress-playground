.PHONY: install default clean clean-themes clean-plugins clean-db

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

clean: clean-plugins clean-themes clean-db
	rm -f public/wp-config.php
	rm -rf public/wp-content/uploads

clean-themes:
	for theme in `wp theme list --field=name 2> /dev/null | grep -v -E '^twenty(fif|four|thir)teen$$'`; do wp theme uninstall --deactivate $$theme; done

clean-plugins:
	for plugin in `wp plugin list --field=name 2> /dev/null | grep -v -E '^akismet|hello$$'`; do wp plugin uninstall --deactivate $$plugin; done

clean-db:
	wp db drop --yes
