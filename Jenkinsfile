pipeline {
    agent { label 'slave01' }
    environment {
        IMAGE_NAME = 'doctor-online'
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_USER = 'lalith767'
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials') // Reference the Jenkins credentials
    }
    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: 'github-token', url: 'https://github.com/lalithfortv/doctor-online.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Get the Git commit short hash for the tag
                    def tag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.DOCKER_TAG = "${DOCKER_REGISTRY}/${DOCKER_USER}/${IMAGE_NAME}:${tag}"
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_TAG} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Authenticate and push to Docker Hub
                    docker.withRegistry('https://docker.io', 'docker-hub-credentials') {
                        sh "docker push ${DOCKER_TAG}"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update Kubernetes deployment YAML with the new image tag
                    sh "sed -i 's|IMAGE_PLACEHOLDER|${DOCKER_TAG}|' k8s-deployment.yaml"
                    // Apply the deployment in Kubernetes
                    sh "kubectl apply -f k8s-deployment.yaml"
                    // Scale the deployment to 3 replicas
                    sh "kubectl scale deployment doctor-online --replicas=3"
                }
            }
        }
    }
    post {
        always {
            cleanWs() // Clean workspace after the pipeline run
        }
    }
}
