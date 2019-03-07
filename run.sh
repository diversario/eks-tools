#!/bin/sh

docker run -rm -it \
  -v $HOME/.helm:$HOME/.helm \
  -v $HOME/.kube:$HOME/.kube \
  -v $HOME/.aws:$HOME/.aws \
  -e USER=$USER \
  -e UID=$UID \
  -e GID=$(id -G | cut -d' ' -f1) \
  -e KUBECONFIG=$HOME/.kube/config \
  -e HELM_HOME=$HOME/.helm \
  -e AWS_SHARED_CREDENTIALS_FILE=$HOME/.aws/credentials \
  -e AWS_CONFIG_FILE=$HOME/.aws/config \
  eks-tools:latest -- $@