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

	# Move our files
	cp $PROVISION_DIR/index.php $SITE_DIR
	cp $PROVISION_DIR/wp-config.php $SITE_DIR

else
	printf "\n#\n# Updating $SITE_DOMAIN\n#\n"

	svn up $SITE_DIR/
	svn up $SITE_DIR/glotpress
	svn up $SITE_DIR/gp-plugins

fi

# Pull global header/footer
curl -o $SITE_DIR/header.php https://wordpress.org/header.php
sed -i 's/<\/head>/\n<?php gp_head(); ?>\n\n&/' $SITE_DIR/header.php
sed -i 's/<body id="wordpress-org" >/<body id="wordpress-org" class="no-js">/' $SITE_DIR/header.php
sed -i 's/<title>WordPress<\/title>/<title><?php echo gp_title(); ?><\/title>/' $SITE_DIR/header.php

curl -o $SITE_DIR/footer.php https://wordpress.org/footer.php
sed -i 's/<\/body>/\n<?php gp_footer(); ?>\n\n&/' $SITE_DIR/footer.php


