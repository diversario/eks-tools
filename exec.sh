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

if [[ -d $HOST_HOME/.helm-host ]]; then
  cp -r $HOST_HOME/.helm-host $HOST_HOME/.helm
fi

if [[ ! -z $UID ]]; then
  if [[ -d $HOST_HOME/.kube ]]; then
    chown -R $USER:$GROUP $HOST_HOME/.kube
  fi

  if [[ -d $HOST_HOME/.helm ]]; then
    chown -R $USER:$GROUP $HOST_HOME/.helm
  fi

  if [[ -d $HOST_HOME/.aws ]]; then
    chown -R $USER:$GROUP $HOST_HOME/.aws
  fi

  su-exec $USER:$GID ${@}
else
  $@
fi