#!/bin/bash
set -euo pipefail


### Init.
declare -r CUR=$(cd $(dirname $0); pwd)
. var.conf

pushd ${CUR} > /dev/null


### Install.
pushd /tmp > /dev/null

# Get Installer file.
curl -O ${INSTALLER_DOWNLOAD_URL}
declare -r installer_name=$(echo ${INSTALLER_DOWNLOAD_URL} | sed -e 's#http://.*/##')
chmod u+x ./${installer_name}

# Prepare install option file.
sed -e "s/#ALFRESCO_ADMIN_PASS#/${ALFRESCO_ADMIN_PASS}/" ${CUR}/conf/optionfile.tmpl > ./optionfile

# Install mysql-5.7.
pushd ../../mysql/mysql-5.7/ > /dev/null
./install.sh
. ./var.conf
popd > /dev/null

# Create Database.
sed -e "s/#ALFRESCO_DB_NAME#/${ALFRESCO_DB_NAME}/" \
    -e "s/#ALFRESCO_DB_USER#/${ALFRESCO_DB_USER}/" \
    -e "s/#ALFRESCO_DB_PASS#/${ALFRESCO_DB_PASS}/" \
  ${CUR}/conf/create_database.sh.tmpl > ./create_database.sh

mysql -uroot -p${MYSQL_ROOT_PASS} < ./create_database.sh


### End
popd > /dev/null
