String credentialsId = 'AWS_4_TERRAFORM'

pipeline{

    agent any

    stages{
        stage("Terraform Initialization"){
            steps{
                def tfHome = tool name: 'TERRAFORM_PKG', type: 'terraform'
                env.Path = "${tfHome};${env.Path}"
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                credentialsId: 'AWS_4_TERRAFORM', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform init'
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