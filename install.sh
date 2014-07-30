#!/bin/bash
set -x

# XXX This is a total hack. We need to have apache do this be default
grep '. /etc/environment' /etc/apache2/envvars

if [ $? -eq 1 ]; then
    echo '. /etc/environment' >> /etc/apache2/envvars
fi

SCRIPT_DIR=$(dirname $0)
pushd $SCRIPT_DIR
    pip install -r requirements.txt
    cp dpaste/settings/local.py.heat dpaste/settings/local.py
    . /etc/environment
    python manage.py syncdb --migrate
popd

service apache2 restart
