pipeline {
    agent any

    stages {
        
        stage("terraform_plan") {
            steps {
                
                sh 'terraform init'
                sh 'az login'
                sh 'terraform plan'
            }
        }
        
        stage("test") {
            steps {
                echo 'Testing'
            }
        }
        
        stage("deploy") {
            steps {
                echo 'Deploy'
            }
        }
    }
}
