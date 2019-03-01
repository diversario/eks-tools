#!/bin/sh

docker run -rm -it \
  -v $HOME/.helm:$HOME/.helm-host \
  -v $HOME/.kube:$HOME/.kube-host \
  -v $HOME/.aws:$HOME/.aws \
  -e USER=$USER \
  -e UID=$UID \
  -e GID=$(id -G | cut -d' ' -f1) \
  -e KUBECONFIG=$HOME/.kube/config \
  -e HELM_HOME=$HOME/.helm \
  eks-tools:latest -- $@