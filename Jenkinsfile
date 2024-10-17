pipeline {
    agent any
    stages {
        stage('Git Checkout') {
          steps {
            echo 'This stage is to clone the repo from github'
            git branch: 'master', url: 'https://github.com/Pallavic9/star-agile-banking-finance.git'
                }
        }
        stage('Create Package') {
          steps {
            echo 'This stage will compile, test, package my application'
            sh 'mvn package'
                }
            }
       stage('Generate Test Reports') {
           steps {
               publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/finance-project/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                    }
            }
       stage('Create Docker Image') {
           steps {
               sh 'docker build -t pallavic9/bankingproject:1.0 .'
                    }
                }
       stage('Docker-Login') {
           steps {
               withCredentials([usernamePassword(credentialsId: 'Dockercreds', passwordVariable: 'dockerpassword', usernameVariable: 'dockerlogin')]) {
               sh 'docker login -u ${dockerlogin} -p ${dockerpassword}'
                                   }
                        }
                }
       stage('Push-Image') {
           steps {
               sh 'docker push pallavic9/bankingproject:1.0'
                     }
                }
         stage('Config & Deployment') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AwsAccessKey', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                
                    sh 'sudo chmod 600 devops-key.pem'
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
                    sh 'terraform destroy --auto-approve'
                        }
                    }
                }
            
        }
}
             
