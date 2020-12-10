pipeline{

    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        BACKEND = "backend-config"
    }

    stages{
        stage("Terraform Initialization"){
            steps{
                steps{
                    script{
                        terraform init "${params.BACKEND}=access_key=${params.AWS_ACCESS_KEY_ID}  ${params.BACKEND}=secret_key=${params.AWS_SECRET_ACCESS_KEY}"
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
                    terraform apply -auto-approve
                }
            }
        }  
        
    }
}