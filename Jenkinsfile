pipeline {
    agent none
    triggers { cron('H H(0-2) * * 1') }
    environment {
        JUPYTER_VERSION = '7.4.2'
    }
    stages {
        stage('Jupyter Images') {
            matrix {
                axes {
                    axis {
                        name 'IMAGE_NAME'
                        values 'jupyter-base', 'scipy-base', 'pytorch-base'
                    }
                    axis {
                        name 'AGENT'
                        values 'jupyter', 'jupyter-arm'
                    }
                    axis {
                        name 'STREAM'
                        values 'stable', 'integration'
                    }
                    axis {
                        name 'CUDA_VER'
                        values 'none', 'cuda11', 'cuda12'
                    }
                }
                excludes {
                    exclude {
                        axis {
                            name 'IMAGE_NAME'
                            notValues 'pytorch-base'
                        }
                        axis {
                            name 'CUDA_VER'
                            notValues 'none'
                        }
                    }
                    exclude {
                        axis {
                            name 'AGENT'
                            values 'jupyter-arm'
                        }
                        axis {
                            name 'CUDA_VER'
                            notValues 'none'
                        }
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
                                    IMG_PREFIX = """${sh(
                                        returnStdout: true,
                                        script: '[ "jupyter-arm" == "$AGENT" ] && echo "aarch64-" || ( [ "pytorch-base" == "$IMAGE_NAME" -a "$CUDA_VER" != "none" ] && echo "${CUDA_VER}-" ||  echo "" )'
                                    ).trim()}"""
                                    IMG_BASE = """${sh(
                                        returnStdout: true,
                                        script: '[ "scipy-base" == "$IMAGE_NAME" ] && echo "scipy" || ( [ "pytorch-base" == "$IMAGE_NAME" ] && echo "pytorch" || echo "base" )'
                                    ).trim()}"""        
                                    IMG_VERSION = """${sh(
                                        returnStdout: true,
                                        script: '[ "integration" == "$STREAM" ] && echo "latest" || echo "${JUPYTER_VERSION}"'
                                    ).trim()}""" 
                                }
                                steps {
                                    script{
                                        try {
                                            if (currentBuild.getBuildCauses('com.cloudbees.jenkins.GitHubPushCause').size() || currentBuild.getBuildCauses('jenkins.branch.BranchIndexingCause').size()) {
                                                scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                                            }
                                            echo "NODE_NAME = ${env.NODE_NAME}"
                                            sh 'podman build -t localhost/$IMAGE_NAME --pull --force-rm --no-cache --from=quay.io/jupyter/${IMG_BASE}-notebook:${IMG_PREFIX}$([ "stable" == "${STREAM}" ] && echo "notebook-")${IMG_VERSION} .'
                                        } catch (e) {
                                            if ( "jupyter-arm" == env.AGENT ) {
                                                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE'){
                                                    error ${e}
                                                }
                                            } else {
                                                throw ${e}
                                            }
                                        }
                                    }
                                }
                            }
                            stage('Test') {
                                steps {
                                    script {
                                        try {
                                            sh 'podman run -it --rm --pull=never localhost/$IMAGE_NAME python -c "import numpy; import pandas; import matplotlib"'
                                            if ( "scipy-base" == env.IMAGE_NAME ) {
                                                sh 'podman run -it --rm --pull=never localhost/$IMAGE_NAME python -c "from scipy import linalg, optimize"'
                                            }
                                            sh 'podman run -d --name=$IMAGE_NAME --network=slirp4netns --rm --pull=never -p 8888:8888 localhost/$IMAGE_NAME start-notebook.sh --NotebookApp.token="jenkinstest"'
                                            sh 'sleep 10 && curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$" || ( sleep 30 && curl -v http://localhost:8888/lab?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$" )'
                                            sh 'curl -v http://localhost:8888/tree?token=jenkinstest 2>&1 | grep -P "HTTP\\S+\\s200\\s+[\\w\\s]+\\s*$"'
                                        } catch (e) {
                                            if ( "jupyter-arm" == env.AGENT ) {
                                                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE', message: ${e}){
                                                    error ${e}
                                                }
                                            } else {
                                                throw ${e}
                                            }
                                        }
                                    }
                                }
                                post {
                                    always {
                                        sh 'podman rm -ifv $IMAGE_NAME'
                                    }
                                }
                            }
                            stage('Deploy') {
                                when { 
                                    allOf {
                                        branch 'main'
                                    }
                                }
                                environment {
                                    DOCKER_HUB_CREDS = credentials('DockerHubToken')
                                    IMG_PREFIX = """${sh(
                                        returnStdout: true,
                                        script: '[ "none" != "$CUDA_VER" ] && echo "${CUDA_VER}-" || echo ""'
                                    ).trim()}"""     
                                    IMG_SUFFIX = """${sh(
                                        returnStdout: true,
                                        script: '[ "jupyter-arm" == "$AGENT" ] && echo "-aarch64" || echo ""'
                                    ).trim()}"""                                    
                                }
                                stages{
                                    stage('Deploy latest/version tag') {
                                        when { environment name: 'STREAM', value: 'stable' }
                                        steps {
                                            retry(5) {
                                                sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/${IMAGE_NAME}:${IMG_PREFIX}latest${IMG_SUFFIX} --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                            }
                                            retry(5) {
                                                sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/${IMAGE_NAME}:${IMG_PREFIX}v$(date "+%Y%m%d")${IMG_SUFFIX} --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                            }
                                        }
                                    }
                                    stage('Deploy weekly tag') {
                                        when { environment name: 'STREAM', value: 'integration' }
                                        steps {
                                            sh 'skopeo copy containers-storage:localhost/$IMAGE_NAME docker://docker.io/ucsb/${IMAGE_NAME}:${IMG_PREFIX}weekly${IMG_SUFFIX} --dest-username $DOCKER_HUB_CREDS_USR --dest-password $DOCKER_HUB_CREDS_PSW'
                                        }
                                        post {
                                            always {
                                                sh 'podman rmi -i $IMAGE_NAME || true'
                                            }
                                        }
                                    }
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
            slackSend(channel: '#infrastructure-build', username: 'jenkins', color: 'good', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(channel: '#infrastructure-build', username: 'jenkins', color: 'danger', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
