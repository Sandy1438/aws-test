pipeline{

    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
        BACKEND = "backend-config"
    }

    stages{
        stage("Terraform Initialization"){
            steps{
                steps{
                    script{
                        withEnv(['"BACKEND=${env.BACKEND}"', '"AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY}"', '"AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_KEY}"']) {
                           sh 'terraform init -backend-config=access_key=${env.AWS_ACCESS_KEY_ID}  -backend-config=secret_key=${env.AWS_SECRET_ACCESS_KEY}'
}
                    }
                }
            }
        }

        stage("Terraform plan"){
            steps{
                script{
                    terraform plan
                }
            }
        }

        stage("Terraform apply"){
            steps{
                script{
                    terraform apply auto-approve
                }
            }
        }  
        
    }
}