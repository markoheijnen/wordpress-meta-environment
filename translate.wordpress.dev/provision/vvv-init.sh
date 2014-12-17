#!/bin/bash
SITE_DOMAIN="translate.wordpress.dev"
BASE_DIR=$( dirname $( dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ) )
PROVISION_DIR="$BASE_DIR/$SITE_DOMAIN/provision"
SITE_DIR="$BASE_DIR/$SITE_DOMAIN/public_html"

source $BASE_DIR/helper-functions.sh
wme_create_logs "$BASE_DIR/$SITE_DOMAIN/logs"

if [ ! -d $SITE_DIR ]; then
	printf "\n#\n# Provisioning $SITE_DOMAIN\n#\n"

	#wme_import_database "translate_wordpress_dev" $PROVISION_DIR

	# Check out Translate.WordPress.org template
	svn co https://meta.svn.wordpress.org/sites/trunk/translate.wordpress.org/public_html/ $SITE_DIR

	# Setup GlotPress
	svn co https://glotpress.svn.wordpress.org/trunk/ $SITE_DIR/glotpress

	# Setup Plugins
	svn co https://meta.svn.wordpress.org/sites/trunk/translate.wordpress.org/includes/gp-plugins/ $SITE_DIR/gp-plugins

else
	printf "\n#\n# Updating $SITE_DOMAIN\n#\n"

	svn up $SITE_DIR/
	svn up $SITE_DIR/glotpress
	svn up $SITE_DIR/gp-plugins

fi
