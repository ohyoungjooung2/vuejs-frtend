pipeline {
  //agent any
  agent  
  {
      docker {
          image 'node:lts-buster-slim'
          args '-p 3000:3000'

        }
    }
  
  environment {
       KUBECONFIG="/home/oyj/.kube/config2"
  }

//  tools {
//   #maven 'maven36'
//
//  }
  

   options {
        skipStagesAfterUnstable()
    }
   stages {
        stage('Build') {
            
            environment {
               test = 'test'       

            }

            steps {
                sh 'npm install'
            }
        }

        stage('Test'){
            steps{
                sh 'echo build is done in docker'
            }
               }

    }

    post {
        always {
             sh 'chmod 755 ./deliver.sh'
             sh './deliver.sh'
          }
     }
}
