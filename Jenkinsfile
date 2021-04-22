pipeline {
    agent any

        stage("terraform_plan") {
            steps {
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
