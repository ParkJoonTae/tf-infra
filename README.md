# tf-infra 리포지토리

이 리포지토리는 AWS에서 EKS 클러스터와 관련된 인프라를 Terraform을 사용하여 구축하고 관리하기 위한 코드들을 포함하고 있습니다.

## 리포지토리 구조

```plaintext
tf-infra/
├── README.md
├── eks/
│   ├── alb-controller-helm.tf
│   ├── alb-controller-policy.tf
│   ├── ca-helm.tf
│   ├── ca-policy.tf
│   ├── data.tf
│   ├── ebs-csi.tf
│   ├── eks-cluster.tf
│   ├── grafana-ingress.yaml
│   ├── iamserviceaccount.tf
│   ├── prometheus-grafana-helm.tf
│   └── provider.tf
├── eks-bastion/
│   ├── bastion-userdata.sh
│   ├── data.tf
│   └── eks-bastion.tf
├── rustapi-helm-chart/
│   ├── Chart.yaml
│   ├── templates/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
└── vpc/
    ├── provider.tf
    ├── variables.tf
    └── vpc.tf

### 1. VPC 설정 (vpc 디렉토리)
VPC에 2개의 public/private Subnet과 IGW, NAT GW를 구성합니다.

- **provider.tf**: AWS provider 설정 파일입니다.
- **variables.tf**: VPC 생성에 필요한 변수들을 정의합니다.
- **vpc.tf**: VPC, 서브넷, 라우팅 테이블 등을 포함한 네트워크 인프라를 구성합니다.

### 2. EKS 클러스터 설정 (eks 디렉토리)
EKS와 ALB 애드온, 

- **provider.tf**: AWS, Kubernetes, Helm, S3 상태관리 provider 설정 파일입니다.
- **data.tf**: data 참조 파일입니다.
- **eks-cluster.tf**: EKS와 관리형 노드 그룹, 보안 그룹 등을 생성합니다.
- **alb-controller-helm.tf**: AWS Load Balancer Controller를 설치하기 위해 Helm Chart를 사용해 EKS에 배포합니다.
- **alb-controller-iam.tf**: ALB Controller가 EKS에서 작동할 수 있도록 필요한 IAM 정책, 역할을 정의합니다.
- **ca-helm.tf**: Cluster Autoscaler를 설치하기 위한 Helm Chart를 사용해 EKS에 배포합니다.
- **ca-iam.tf**: Cluster Autoscaler에 필요한 IAM 정책을 정의합니다.
- **ebs-csi.tf**: EKS에서 EBS CSI 드라이버를 사용하기 위한 애드온과 IAM 역할을 정의합니다.
- **grafana-ingress.yaml**: Grafana Ingress를 정의하여 ALB를 통해 외부에서 접근할 수 있도록 설정합니다.
- **iamserviceaccount.tf**: ALB와 CA에 필요한 IAM Service Account를 생성하는 코드입니다.
- **prometheus-grafana-helm.tf**: Prometheus 및 Grafana를 설치하기 위한 Helm Chart를 사용해 EKS에 배포합니다.- **prometheus-grafana-helm.tf**: Prometheus 및 Grafana를 설치하기 위한 Helm Chart를 사용해 EKS에 배포합니다.

### 3. Bastion 호스트 설정 (eks-bastion 디렉토리)

- **bastion-userdata.sh**: Bastion 호스트 인스턴스의 초기 설정 스크립트입니다. SSH 키 설정 및 필수 패키지 설치를 처리합니다.
- **data.tf**: Bastion 호스트에 필요한 VPC 및 서브넷 정보를 불러옵니다.
- **eks-bastion.tf**: Bastion 호스트 인스턴스를 정의하는 Terraform 코드입니다.

### 4. Rust API 서버 설정 (rustapi-helm-chart 디렉토리)

- **Chart.yaml**: Helm 차트에 대한 메타데이터를 정의합니다.
- **values.yaml**: 차트의 기본값을 정의하는 파일로, 배포할 애플리케이션의 설정이 포함됩니다.
- **templates/**: Kubernetes 리소스 템플릿들이 포함된 디렉토리입니다.
    - **deployment.yaml**: Rust API 서버의 배포 설정을 정의합니다.
    - **ingress.yaml**: Ingress 리소스를 정의하여 API 서버에 대한 외부 접근을 설정합니다.
    - **pvc.yaml**: 퍼시스턴트 볼륨 클레임(PVC)을 정의하여 데이터 저장소를 설정합니다.
    - **service.yaml**: Kubernetes 서비스 설정을 정의하여 애플리케이션의 네트워킹을 관리합니다.