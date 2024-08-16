#!/bin/bash

# awscli 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

cat << 'EOL' >> /home/ec2-user/.bashrc 
complete -C '/usr/local/bin/aws_completer' aws

export AWS_DEFAULT_REGION=ap-northeast-2
export AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>
EOL

# eksctl 설치
PLATFORM=$(uname -s)_amd64
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# kubectl 설치
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.3/2024-04-19/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && sudo mv ./kubectl /usr/local/bin
echo 'export PATH=$HOME/bin:$PATH' >> /home/ec2-user/.bashrc 

# ec2-user로 전환해 명령어 실행
# root로 aks eks update-kubeconfig 명령어 실행하면 ec2-user에 kubectl 설정 안됨
# k8s 설정을 eks의 pjt-eks로 설정
su - ec2-user -c 'bash -s' <<'EOF'
aws eks update-kubeconfig --name pjt-eks --region ap-northeast-2
EOF

# git 설치
sudo yum install git -y

# helm 설치
cd /home/ec2-user && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
cd /home/ec2-user && chmod 700 get_helm.sh
/home/ec2-user/get_helm.sh