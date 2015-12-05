.PHONY: install default clean

default:
	@echo 'Install'
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
	wp theme list --field=name | grep -v -E '^twenty(fif|four|thir)teen$$' | xargs wp theme uninstall
	wp plugin list --field=name | grep -v -E '^akismet|hello$$' | xargs wp plugin uninstall
	wp db drop --yes
	rm -f public/wp-config.php
	rm -rf public/wp-content/uploads
