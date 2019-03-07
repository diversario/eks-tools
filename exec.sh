#!/bin/sh

# Setup user/group that matches host user's UID/GID
# to avoid application in the container modifying
# file ownership to root
if [[ ! -z $UID ]]; then
  adduser -D -h $HOST_HOME -u $UID $USER

  if [[ ! -z $GID ]]; then
    GROUP=

    if grep -q ":$GID:" /etc/group; then
      GROUP=$(getent group $GID | cut -d: -f1)
    else
      GROUP=dockergroup
      addgroup -g $GID $GROUP
    fi

    addgroup $USER $GROUP
  fi
fi

if [[ -d $HOST_HOME/.kube-host ]]; then
  cp -r $HOST_HOME/.kube-host $HOST_HOME/.kube
fi

if [[ ! -z $UID ]]; then
  su-exec $USER:$GID "${@}"
else
  su-exec root:root "${@}"
fi