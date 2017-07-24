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
sed -e "s/#ADMIN_PASS#/${ADMIN_PASS}/" ${CUR}/conf/optionfile.tmpl > ./optionfile

popd > /dev/null


### End
popd > /dev/null
