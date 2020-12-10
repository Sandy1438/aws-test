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
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_4_TERRAFORM', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform init -backend-config=access_key=${AWS_ACCESS_KEY_ID}  -backend-config=secret_key=${AWS_SECRET_ACCESS_KEY}'
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