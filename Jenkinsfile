pipeline {
    agent any

    stages {
        
        stage("terraform_plan") {
            steps {
                 sh "${env.TERRAFORM_HOME}/terraform init -input=false"
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
