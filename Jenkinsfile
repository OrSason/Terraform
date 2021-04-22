pipeline {
    agent any

    stages {
        
        stage("terraform_plan") {
            steps {
                sh 'cd /'
                sh 'mkdir App'
                sh 'cd App'
                sh 'terraform init'
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
