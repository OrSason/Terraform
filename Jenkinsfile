String credentialsID = 'azureCredentials'

pipeline {
    agent {label 'slave'}

    stages {

        stage("checkout") {
            steps {
                echo 'Deploy'
            }
        }
        
        stage("terraform_plan") {
            steps {


        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: credentialsID, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
        sh 'az login -u $USERNAME -p $PASSWORD'
         }
                
                sh 'terraform init'
                sh 'terraform plan'
            }
        }
        
        stage("Deploy infastructure") {
            steps {
                sh 'terraform apply -auto-approve '
            }
        }
        
        stage("deploy") {
            steps {
                echo 'Deploy'
            }
        }
    }
}
