pipeline {
    agent any

    tools {
            maven 'Maven 3.8.6'
            jdk 'jdk17'
     }

    stages {
        stage("build"){
            steps{
                echo 'building the application...'
                sh 'mvn install'
            }
        }
    }
}