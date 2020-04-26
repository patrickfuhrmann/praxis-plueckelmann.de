#!/bin/bash
#
if [ $# -lt 1 ] ; then
   echo "Usage : ... <deplysite>"
   exit 2
fi
#
DEPLOY_DIR=$1
#
MASTER=/home/patrick/jekyll/plueckelmann.de
KEY=${MASTER}/_deploy/ssh-key.private
TMPBATCH=/tmp/3524478e.batch
USER_NAME=105284-trude
HOST_NAME=ftp.praxis-plueckelmann.de
FULL_DEPLOY_DIR=${MASTER}/${DEPLOY_DIR}
#
if [ ! -d ${MASTER} ] ; then
   echo "Master directory not found : ${MASTER}" >&2
   exit 1
fi
#if [ ! -d ${FULL_DEPLOY_DIR} ] ; then
#   echo "Deploy directory not found : ${FULL_DEPLOY_DIR}" >&2
#   exit 1
#fi
if [ ! -f ${KEY} ] ; then
   echo "Private key not found : ${KEY}" >&2
   exit 1
fi
#
cat >${TMPBATCH} <<!
put -r ${DEPLOY_DIR}
exit
!
#
cd ${MASTER}
jekyll build
if [ $? -ne 0 ] ; then exit $? ; fi
rm -rf ${DEPLOY_DIR}
mv _site ${DEPLOY_DIR}
#
sftp -b ${TMPBATCH} -i ${KEY} ${USER_NAME}@${HOST_NAME}
#
exit 0
