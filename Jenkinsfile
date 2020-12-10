String credentialsId = 'AWS_4_TERRAFORM'
def tfHome = tool name: 'TERRAFORM_PKG', type: 'terraform'
env.Path = "${tfHome};${env.Path}"

pipeline{

    agent any

    environment{
        String credentialsId = 'AWS_4_TERRAFORM'
        tfHome = tool name: 'TERRAFORM_PKG', type: 'terraform'
        env.Path = "${tfHome};${env.Path}"
    }

    stages{
        stage("Terraform Initialization"){
            steps{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                credentialsId: 'AWS_4_TERRAFORM', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh '${env.Path}/terraform init'
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