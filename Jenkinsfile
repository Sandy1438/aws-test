String credentialsId = 'AWS_4_TERRAFORM'

pipeline{

    agent any

    stages{
        stage("Terraform Initialization"){
            steps{
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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                credentialsId: 'AWS_4_TERRAFORM', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform refresh'
                }
            }
        }

        stage("Terraform apply"){
            steps{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                credentialsId: 'AWS_4_TERRAFORM', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {               
                   sh 'terraform destroy -auto-approve'
                }
            }
        }  
        
    }
}