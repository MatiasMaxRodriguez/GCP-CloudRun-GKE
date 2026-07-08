# GCP-CloudRun-GKE
## Proyecto: Conexión segura Cloud Run a MongoDB en GKE
Para este proyecto se despliega una arquitectura de red híbrida implementada para conectar un
microservicio serverless alojado en Google Cloud Run con una base de datos MongoDB
persistente que corre dentro de un clúster de Google Kubernetes Engine (GKE), utilizando
enrutamiento interno seguro mediante Serverless VPC Access y exposición por NodePort.

El deploy del proyecto, junto con todas las configuraciones y dependencias, se realizó con la siguiente estructura:

-> /app-node-gcpinfracloudrun
- app.js
- mongodb-deploy.yaml
- package.json

-> /gcp-infra-cloudrun
- .terraform.lock.hcl
- main.tf
- mongodb-deploy.yaml
- outputs.tf
- providers.tf
- variables.tf

-> /gcp-infra-cloudrun/modules

-> ~/compute
- main.tf
- outputs.tf
- variables.tf
  
-> ~/database
- main.tf
- outputs.tf
- variables.tf

-> ~/gke
- main.tf
- outputs.tf
- variables.tf

-> ~/networking
- main.tf
- outputs.tf
- variables.tf

## Diagrama del proyecto

![diagrama del proyecto](https://github.com/MatiasMaxRodriguez/GCP-CloudRun-GKE/blob/main/gcp-cloudrun-gke.drawio.png)

## Tecnologías utilizadas:

[Google GKE](https://cloud.google.com/kubernetes-engine?hl=es-419)
[Google VPC](https://cloud.google.com/vpc?hl=es-419)
[Terraform](https://developer.hashicorp.com/terraform)
[Docker](https://www.docker.com/)
[Kubernetes](https://kubernetes.io/es/)
[Node.js](https://nodejs.org/es)
[MongoDB](https://www.mongodb.com/es)
