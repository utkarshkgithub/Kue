import psycopg2
import os

# Path to the schema file
table_schema_path = os.path.join(os.path.dirname(__file__), 'schema.sql')

def strip_quotes(value):
    if value is None:
        return None
    return value.strip("'\"")

# Database connection parameters (use environment variables)
DB_HOST = strip_quotes(os.getenv("PGHOST", "localhost"))
DB_NAME = strip_quotes(os.getenv("PGDATABASE", "blogdb"))
DB_USER = strip_quotes(os.getenv("PGUSER", "user"))
DB_PASSWORD = strip_quotes(os.getenv("PGPASSWORD", "password"))
DB_PORT = strip_quotes(os.getenv("PGPORT", "5432"))


conn_params = {
    "host": DB_HOST, "dbname": DB_NAME, "user": DB_USER, "password": DB_PASSWORD, "port": DB_PORT
}


# Define the posts to insert
posts = [
    (
        'Docker Compose Best Practices',
        'Learn how to use Docker Compose to define and run multi-container applications. '  
        'Best practices include: organizing your docker-compose files for dev/prod, '  
        'using multiple compose files for overrides, leveraging environment files and Docker secrets, '  
        'splitting large stacks into smaller service groups, health checks for service readiness, '  
        'and named volumes for persistent data.'
    ),
    (
        'Helm Charts for Kubernetes',
        'Helm is the package manager for Kubernetes. Helm charts help you define, install, '  
        'and upgrade even the most complex Kubernetes applications. This guide covers chart structure, '  
        'versioning strategies, values.yaml patterns, template functions, dependency management, '  
        'and CI/CD linting & testing best practices.'
    ),
    (
        'Service Mesh with Istio',
        'Istio provides a way to control how microservices share data with one another. It includes '  
        'capabilities such as traffic management (canary releases, A/B testing), security (mTLS, authn/z), '  
        "and observability (telemetry, tracing, metrics). We'll walk through VirtualService, DestinationRule, "
        'and integrating with Prometheus/Grafana & Jaeger.'
    ),
    (
        'Kubernetes Operators',
        'Operators are software extensions to Kubernetes that make use of custom resources to manage '  
        'applications and their components. We compare frameworks (Operator SDK vs. Kubebuilder), discuss '  
        'CRD versioning, upgrade strategies, and best practices for packaging and testing your operator.'
    ),
    (
        'Cloud Native CI/CD',
        'Implementing CI/CD pipelines in cloud native environments enables faster and more reliable '  
        'software delivery. This post walks through Tekton for pipelines (Task, Pipeline, Trigger) '  
        'and ArgoCD for GitOps-driven continuous deployment, with security tips for secrets management '  
        'and multi-cluster sync.'
    ),
    (
        'Pod Security Policies',
        'Pod Security Policies (PSP) enable fine-grained authorization of pod creation and updates, '  
        'helping you secure your Kubernetes workloads. We cover policy syntax, allowed capabilities, '  
        'seccomp profiles, deprecation & replacement with Pod Security Admission, and Gatekeeper examples.'
    ),
    (
        'Kubernetes Networking 101',
        'Understand the basics of Kubernetes networking: Service types (ClusterIP, NodePort, LoadBalancer), '  
        'Ingress controllers & routing rules, NetworkPolicy enforcement with sample YAML, DNS resolution via CoreDNS, '  
        'and best practices for production clusters.'
    ),
    (
        'Container Image Scanning',
        'Scanning container images for vulnerabilities is a critical step in securing your cloud native applications. '  
        'We compare tools like Trivy and Clair, demonstrate CI integration commands, discuss SBOM generation, '  
        'and show automated repair workflows for base image updates.'
    )
]


def init_db():
    # Connect to PostgreSQL database
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()
    try:
        # Execute schema to create tables
        print(f"Reading schema from {table_schema_path}")
        with open(table_schema_path, 'r') as f:
            # For psycopg2, execute the content.
            cur.execute(f.read())

        # Insert posts
        insert_sql = 'INSERT INTO posts (title, content) VALUES (%s, %s)'
        cur.executemany(insert_sql, posts)

        # Commit changes
        conn.commit()
        print(f"Initialized PostgreSQL database '{DB_NAME}' on host '{DB_HOST}' and inserted {len(posts)} posts into 'posts' table.")

    except Exception as e:
        print(f"Error during database initialization: {e}")
    finally:
        cur.close()
        conn.close()


if __name__ == '__main__':
    init_db()
