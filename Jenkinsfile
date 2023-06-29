pipeline {
    agent any

    tools {
            maven 'Maven 3.8.6'
            jdk 'jdk17'
     }

     environment {
             NEXUS_VERSION = "nexus3"
             NEXUS_PROTOCOL = "http"
             NEXUS_URL = "nexus:8081"
             NEXUS_REPOSITORY = "maven-nexus-repo"
             NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
         }

    stages {
        stage("build"){
            steps{
                echo 'building the application...'
                sh 'mvn clean compile'
            }
        }
        stage("test"){
            steps{
                echo 'testing the application...'
                sh 'mvn test'
            }
        }
        stage("robotframework test"){
            steps{
                sh 'cd src/test/robotframework'
                echo "Script executed from: ${PWD}"
                sh 'python3 -m robot.run .'
                sh 'robocop --exclude missing-doc-test-case ./var/jenkins_home/workspace/test-pipeline_dev/src/test/robotframework/testcase_1.robot --reports rules_by_id'
            }
        }
        stage("packaging"){
            steps{
                sh 'mvn package -DskipTests'
            }
        }
        stage("publish"){
            steps{
                script{
                pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        stage("sonarqube"){
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }
            steps{
                withSonarQubeEnv('sonarqube') {
                    sh "mvn sonar:sonar"
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}