pipeline{
    agent any
    stages{
   	stage("Maven Build"){
           steps{
               sh 'mvn package'
           } 
        }
        stage("Dev Deploy"){
           steps{
              sshagent(['tomcat-deploy-key']) {
                // Copy war file to tomcat dev server
                sh "scp -o StrictHostKeyChecking=no target/doctor-online.war ec2-user@100.26.32.135:/opt/tomcat10/webapps/"
                // Restart tomcat server
                sh "ssh ec2-user@100.26.32.135 /opt/tomcat10/bin/shutdown.sh"
                sh "ssh ec2-user@100.26.32.135 /opt/tomcat10/bin/startup.sh"
              }
           } 
        }
    }
}
