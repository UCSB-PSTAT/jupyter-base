pipeline {
    agent none
    triggers { cron('H H(0-6) * * 1') }
    environment {
        JUPYTER_VERSION
    }
    stages {
        stage('Jupyter Images') {
            matrix {
                axes {
                    axis {
                        name 'IMAGE_NAME'
                        values 'jupyter-base', 'scipy-base'
                    }
                    axis {
                        name 'AGENT'
                        values 'jupyter', 'jupyter-arm'
                    }
                }
                stages {
                    stage('Build Test Deploy') {
                        agent {
                            label "${AGENT}"
                        }
                        stages{
                            stage('Build') {
                                environment {
                                    IMG_PREFIX = """${sh
                                        returnStdout: true,
                                        script: '[ "jupyter-arm" == "$AGENT" ] && echo "aarch64-" || echo ""'
                                    })"""
                                    IMG_BASE = """${sh
                                        returnStdout: true,
                                        script: '[ "scipy-base" == "$IMG_NAME" ] && echo "scipy" || echo "base"'
                                    })"""                                    
                                }
                                when { environment name: 'AGENT', value: 'jupyter'}
                                steps {
                                    scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                                    sh 'podman build -t localhost/$IMAGE_NAME --pull --no-cache --from=jupyter/${IMG_BASE}-notebook:${IMG_PREFIX}notebook-${JUPYTER_VERSION} .'
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
                                    IMG_SUFFIX = """${sh
                                        returnStdout: true,
                                        script: '[ "jupyter-arm" == "$AGENT" ] && echo "-aarch64" || echo ""'
                                    })"""                                    
                                }
                                steps {
                                    sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/${IMAGE_NAME}:latest${IMG_SUFFIX} --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                    sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/${IMAGE_NAME}:v$(date "+%Y%m%d")${IMG_SUFFIX} --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
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
