#!/usr/bin/env sh
#
# Create a Kubernetes cluster using multipass
#
# This was developed on RHEL8 and assumes Multipass Snap is installed,
# SELinux disabled as it provides no value in this endeavour and can only
# get in the way, and Bob's your uncle. 
#
# References: https://access.redhat.com/solutions/20985
#
# Tested on: RHEL8
#
# Author: Justin Cook

TMP="${HOME}/.multipass_k8s"
SRV="raw.githubusercontent.com"
PTH="tigera/ccol1/main"

# Fetch each init config and create node
for node in control node{1,2} host1
do
  if [ ! -d "${TMP}" ]
  then
    mkdir ${TMP}
  fi
  multipass info ${node} >/dev/null 2>&1
  if [ $? != 0 ]
  then
    # Delete init files cached longer than two hours
    find ${TMP} -type f -mmin +120 -exec rm {} +
    if [ ! -f "${node}-init.yaml" ]
    then
      curl -s https://${SRV}/${PTH}/${node}-init.yaml -o ${TMP}/${node}-init.yaml
    fi
    echo "Launching ${node}"
    multipass launch -n ${node} -m 2048M 20.04 --cloud-init ${TMP}/${node}-init.yaml
  else
    echo "Found ${node} and starting"
    multipass start ${node}
  fi  
done

# Disable oom-kill for qemu processes
for pid in `pgrep qemu`
do
  echo "Disabling oom-killer for ${pid}"
  sudo bash -c "echo -17 > /proc/${pid}/oom_adj"
done
