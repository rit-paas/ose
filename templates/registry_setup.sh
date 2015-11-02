#!/bin/bash
# Setup of PersistentVolume-backed Registry for OSE 3

export PV_NAME=pv001
export NFS_STORAGE_SIZE=100Gi
export NFS_FQDN=mgmxasfilet01.infra.rit-paas.com
export NFS_PATH=/nfs/ose/pv001

export PVC_STORAGE_SIZE=95Gi

##########################################################
# Add PersistentVolume
##########################################################
echo "apiVersion: v1
kind: PersistentVolume
metadata:
  name: $PV_NAME
spec:
  capacity:
    storage: $NFS_STORAGE_SIZE
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  nfs:
    server: $NFS_FQDN
    path: $NFS_PATH" | oc create -f -

##########################################################
# Add PersistentVolumeClaim
##########################################################
oc project default

echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: registryclaim
spec:
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  resources:
    requests:
      storage: $PVC_STORAGE_SIZE" | oc create -f -

##########################################################
# Deployment of initial registry
##########################################################
oadm registry --config=/etc/openshift/master/admin.kubeconfig \
    --credentials=/etc/openshift/master/openshift-registry.kubeconfig \
    --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' 

##########################################################
# Change DC to use PersistantVolumeClaim
##########################################################
oc volume deploymentconfigs/docker-registry \
    --add --overwrite --name=registry-storage --mount-path=/registry \
    --source='{"persistentVolumeClaim": { "claimName": "registryclaim" }}'
