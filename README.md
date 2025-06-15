# Kue: Devops Blogging Site

Welcome to **Kue**, a cloud-native devops blogging platform. This project demonstrates modern DevOps practices using Kuernetes, Terraform, Flask, and Docker.

## Features

- **News Blogging**: Create, read, and manage news articles.
- **Cloud-Native**: Built for scalability and reliability.
- **Containerized**: All components run in Docker containers.
- **Infrastructure as Code**: Automated provisioning with Terraform.
- **Orchestrated Deployment**: Managed using EKSCluster.

## Tech Stack

- **Flask**: Backend web framework (Python)
- **Docker**: Containerization of application components
- **Kuernetes**: Orchestration and scaling
- **Terraform**: Infrastructure provisioning

## Getting Started

1. **Clone the repository**
    ```bash
    git clone https://github.com/utkarshkgit/Kue.git
    cd cloud_blog
    ```

2. **Provision Infrastructure**
    - Configure your cloud provider credentials.
    ```bash
    aws configure
    ```
    - Run Terraform scripts in the `infrastructure/` directory:
      ```bash
      cd infrastructure
      terraform init
      terraform apply
      ```

3. **Build and Push Docker Images**
    ```bash
    docker build -t <username>/cloud_blog:latest .
    docker push <username>/cloud_blog:latest
    ```

4. **Deploy to Kuernetes**
    - Apply Kuernetes manifests:
      ```bash
      aws eks --region us-east-2 update-Kueconfig --name my-cluster
      Kuectl apply -f k8s/
      ```

5. **Access the Application**
    - Find the service endpoint and open it in your browser.

## Project Structure

```
.
├── app.py            # Flask application code
├── Dockerfile        # Docker build instructions
├── k8s/              # Kuernetes manifests
├── infrastructure/   # Terraform scripts
└── README.md
```

## License

This project is licensed under the MIT License.

---

*Happy blogging in the cloud!*