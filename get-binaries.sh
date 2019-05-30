#!/bin/sh
#set -x

OS=$(uname -a | cut -d' ' -f1 | awk '{print tolower($0)}')

HELM_URL="https://storage.googleapis.com/kubernetes-helm/"
HELM_TAR="helm-vVERSION-$OS-amd64.tar.gz"
KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/vVERSION/bin/$OS/amd64/kubectl"

mkdir -p /bin

for v in '2.12.3'; do
  tar_filename=/tmp/helmv$v.tar.gz
  filter=$OS-amd64/helm
  bin_name=/bin/helm
  url=$HELM_URL$(echo $HELM_TAR | sed -e "s/VERSION/$v/")

  echo "Downloading Helm v$v from $url to $bin_name"

  curl -sL $url -o $tar_filename
  tar xf $tar_filename --strip-components=1 -C /tmp $filter
  mv /tmp/helm $bin_name
  chmod +x $bin_name
done

for v in '1.12.8'; do
  filename=/bin/kubectl
  url=$(echo $KUBECTL_URL | sed -e "s/VERSION/$v/")
  echo "Downloading kubectl v$v from $url to $filename"
  curl -sL $url -o $filename
  chmod +x $filename
done

curl -sL https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator -o /bin/aws-iam-authenticator
chmod a+x /bin/aws-iam-authenticator

curl -sL https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64 -o /bin/yq-merge
chmod a+x /bin/yq-merge

curl -sL https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip -o /tmp/tf.zip
unzip /tmp/tf.zip -d /tmp/ -j
rm /tmp/tf.zip
mv /tmp/terraform /bin/terraform12
chmod a+x /bin/terraform12