pipeline{
    agent { label 'agent1' }
    stages{
   	stage("Maven Build"){
           steps{
               sh 'mvn package'
           } 
        }
        stage("Nexus Upload"){
            steps{
               script{
                def pom = readMavenPom file: 'pom.xml'
                def version = pom.version
                nexusArtifactUploader artifacts: [[artifactId: 'doctor-online', classifier: '', file: 'target/doctor-online.war', type: 'war']], credentialsId: 'nexus3', groupId: 'in.javahome', nexusUrl: '54.226.165.197:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'doctor-online', version: version
               }
            }
        }
        stage("Dev Deploy"){
           steps{
              sshagent(['tomcat-deploy-key']) {
                // Download the .war from Nexus
                sh "curl -o doctor-online.war http://54.226.165.197:8081/repository/doctor-online/in/javahome/doctor-online/${pom.version}/doctor-online.war"
                // Copy war file to tomcat dev server
                sh "scp -o StrictHostKeyChecking=no target/doctor-online.war ec2-user@3.212.43.78:/opt/tomcat10/webapps/"
                // Restart tomcat server
                sh "ssh -o StrictHostKeyChecking=no ec2-user@3.212.43.78 /opt/tomcat10/bin/shutdown.sh"
                sh "ssh -o StrictHostKeyChecking=no ec2-user@3.212.43.78 /opt/tomcat10/bin/startup.sh"
              }
           } 
        }
    }
}