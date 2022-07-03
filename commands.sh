# make .gitignore work
git rm -r --cached .

# vim delete all lines
:%d

# assess AZs in a region
aws ec2 describe-availability-zones --region us-east-2

aws ec2 create-restore-image-task --object-key ami-08dff635fabae32e7.bin --bucket udacity-srend --name "udacity-project-1"
#ami-030c415a676e1cd50
aws ec2 copy-image --source-image-id ami-030c415a676e1cd50 --source-region us-east-1 --region us-east-2 --name "udacity-project-1"
#ami-06b41aa13fa02f388

aws s3api create-bucket --bucket udacity-tf-huiren --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2
aws s3 rm s3://terraform-tf-huiren --recursive
aws s3api delete-bucket --bucket terraform-tf-huiren
aws ec2 create-key-pair --key-name udacity --region us-east-2

# helm
export VERIFY_CHECKSUM=false
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# terraform
wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
unzip terraform_1.0.7_linux_amd64.zip
mkdir ~/bin
mv terraform ~/bin
export TF_PLUGIN_CACHE_DIR="/tmp"

# kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc


aws eks update-kubeconfig --name udacity-cluster #--region us-east-2
#Change kubernetes context to the new AWS cluster
kubectl config current-context
# kubectl config use-context docker-desktop
kubectl config use-context arn:aws:eks:us-east-2:376940003530:cluster/udacity-cluster
# e.g  arn:aws:eks:us-east-2:139802095464:cluster/udacity-cluster
kubectl get pods --all-namespaces
kubectl create namespace monitoring
kubectl get pods --namespace monitoring

kubectl create secret generic additional-scrape-configs --from-file=prometheus-additional.yaml --namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack -f "values.yaml" --namespace monitoring
helm install prometheus-blackbox-exporter prometheus-community/prometheus-blackbox-exporter -f "blackbox-values.yaml" --namespace monitoring
# kubectl delete all --all -n monitoring

# install node-exporter
ssh -i "udacity.pem" ubuntu@ec2-52-14-161-49.us-east-2.compute.amazonaws.com
sudo useradd --no-create-home --shell /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
sudo cp node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo vim /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter
sudo ufw allow 9100/tcp
sudo systemctl restart ufw
# [Unit]
# Description=Node Exporter
# Wants=network-online.target
# After=network-online.target

# [Service]
# User=node_exporter
# Group=node_exporter
# Type=simple
# ExecStart=/usr/local/bin/node_exporter

# [Install]
# WantedBy=multi-user.target



