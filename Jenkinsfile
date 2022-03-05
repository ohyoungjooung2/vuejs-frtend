pipeline {
  agent any
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
                sh 'echo build is done in docker!'
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
