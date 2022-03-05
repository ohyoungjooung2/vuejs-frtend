pipeline {
  agent any
  environment {
       KUBECONFIG="/home/oyj/.kube/config2"
       npm=/fast/tst/node-v13.14.0-linux-x64/bin/npm
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
                sh '$npm install'
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
