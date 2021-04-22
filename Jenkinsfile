pipeline {
    agent any

    stages {
        
        stage("terraform_plan") {
            steps {
                sh 'terraform init'
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
