pipeline {
    agent none
    triggers { cron('H H(0-6) * * 1') }
    stages {
        stage('Jupyter Images') {
            parallel {
                stage('Jupyter Images (x86_64') {
                    matrix {
                        axes {
                            axis {
                                name 'IMAGE_NAME'
                                values 'jupyter-base', 'scipy-base'
                            }
                        }
                    }
                    stages {
                            stage('Build Test Deploy') {
                                agent {
                                    label 'jupyter'
                                }
                                stages{
                                    stage('Build') {
                                        steps {
                                            scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                                            sh 'podman build -t localhost/$IMAGE_NAME --pull --no-cache $([ "scipy-base" == "$IMAGE_NAME" ] && echo "--from=jupyter/scipy-notebook:notebook-6.4.10")  .'
                                         }
                                    }
                                    stage('Test') {
                                        steps {
                                            sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import numpy; import pandas; import matplotlib"'
                                            sh 'podman run -d --name=$IMAGE_NAME --rm -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                                            sh 'sleep 10 && curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                                            sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                                        }
                                        post {
                                            always {
                                                sh 'podman rm -ifv $IMAGE_NAME'
                                            }
                                        }
                                    }
                                    stage('Deploy') {
                                        when { branch 'main' }
                                        environment {
                                            DOCKER_HUB_CREDS = credentials('DockerHubToken')
                                        }
                                        steps {
                                            sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:latest --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                            sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:v$(date "+%Y%m%d") --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                        }
                                    }                
                                }
                            }
                        }
                    }
                stage('Jupyter Images (aarch64') {
                    matrix {
                        axes {
                            axis {
                                name 'IMAGE_NAME'
                                values 'jupyter-base', 'scipy-base'
                            }
                        }
                    }
                    stage('Build Test Deploy') {
                        agent {
                            label 'jupyter-arm'
                        }
                        stages{
                            stage('Build') {
                                steps {
                                    scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                                    sh 'podman build -t localhost/$IMAGE_NAME --pull --no-cache $([ "scipy-base" == "$IMAGE_NAME" ] && echo "--from=jupyter/scipy-notebook:aarch64-notebook-6.4.10" || echo "--from=jupyter/base-notebook:aarch64-notebook-6.4.10" )  .'
                                 }
                            }
                            stage('Test') {
                                steps {
                                    sh 'podman run -it --rm localhost/$IMAGE_NAME python -c "import numpy; import pandas; import matplotlib"'
                                    sh 'podman run -d --name=$IMAGE_NAME --rm -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                                    sh 'sleep 10 && curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                                    sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                                }
                                post {
                                    always {
                                        sh 'podman rm -ifv $IMAGE_NAME'
                                    }
                                }
                            }
                            stage('Deploy') {
                                when { branch 'main' }
                                environment {
                                    DOCKER_HUB_CREDS = credentials('DockerHubToken')
                                }
                                steps {
                                    sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:latest-aarch64 --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                    sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/$IMAGE_NAME:v$(date "+%Y%m%d")-aarch64 --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                }
                            }                
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
