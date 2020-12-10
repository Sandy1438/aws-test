pipeline{

    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages{
        stage("Terraform Initialization"){
            steps{
                steps{
                    script{
                        terraform init backend-config="access_key=${params.AWS_ACCESS_KEY_ID}"  backend-config="secret_key=${params.AWS_SECRET_ACCESS_KEY}"
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
