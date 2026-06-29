pipeline {
    agent none
    triggers { cron('H H(0-2) * * 1') }
    environment {
        JUPYTER_VERSION = '7.5.3'
    }
    stages {
        stage('Jupyter Image Builds') {
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
                        values 'none', 'cuda12', 'cuda13'
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
                                        script: '[ "pytorch-base" == "$IMAGE_NAME" -a "$CUDA_VER" != "none" ] && echo "${CUDA_VER}-" ||  echo "" '
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
                                            sh 'podman run -it --rm --pull=never localhost/$IMAGE_NAME jupyter labextension list | grep "@jupyter-ai" | grep "@jupyter-ai.*enabled.*OK"'
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
                                        script: '[ "jupyter-arm" == "$AGENT" ] && echo "-aarch64" || echo "-amd64"'
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
        stage('Latest and Datecode Manifests') {
            when { branch 'main' }
            agent { label 'podman' }
            environment {
                DOCKER_HUB_CREDS = credentials('DockerHubToken')
            }
            steps {
                //In Theory this only happens when all of the other stages have already deployed. There should be jupyter-base, scipy-base and pytorch-base images with date codes that match latest at this point, and weekly tags for all of those as well. Pytorch has a cuda prefix as well, but we should probably make a simple latest tag that uses the most recent cuda version. 
                //Create manifest for jupyter-base from existing tags and push to latest and datecode tags. 
                sh 'podman manifest create ucsb/jupyter-base:latest'
                sh 'podman manifest add ucsb/jupyter-base:latest docker://docker.io/ucsb/jupyter-base:latest-aarch64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                sh 'podman manifest add ucsb/jupyter-base:latest docker://docker.io/ucsb/jupyter-base:latest-amd64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                retry(6){
                    sh 'podman manifest push ucsb/jupyter-base:latest docker://docker.io/ucsb/jupyter-base:latest --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                    sh 'podman manifest push ucsb/jupyter-base:latest docker://docker.io/ucsb/jupyter-base:v$(date "+%Y%m%d") --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                }
                //Create manifest for scipy-base from existing tags. 
                sh 'podman manifest create ucsb/scipy-base:latest'
                sh 'podman manifest add ucsb/scipy-base:latest docker://docker.io/ucsb/scipy-base:latest-aarch64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                sh 'podman manifest add ucsb/scipy-base:latest docker://docker.io/ucsb/scipy-base:latest-amd64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                retry(6){
                    sh 'podman manifest push ucsb/scipy-base:latest docker://docker.io/ucsb/scipy-base:latest --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                    sh 'podman manifest push ucsb/scipy-base:latest docker://docker.io/ucsb/scipy-base:v$(date "+%Y%m%d") --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                }
                //Create manifest for pytorch-base:cuda12-*  from existing tags. 
                sh 'podman manifest create ucsb/pytorch-base:cuda12-latest'
                sh 'podman manifest add ucsb/pytorch-base:cuda12-latest docker://docker.io/ucsb/pytorch-base:cuda12-latest-aarch64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                sh 'podman manifest add ucsb/pytorch-base:cuda12-latest docker://docker.io/ucsb/pytorch-base:cuda12-latest-amd64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                retry(6){
                    sh 'podman manifest push ucsb/pytorch-base:cuda12-latest docker://docker.io/ucsb/pytorch-base:cuda12-latest --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                    sh 'podman manifest push ucsb/pytorch-base:cuda12-latest docker://docker.io/ucsb/pytorch-base:cuda12-v$(date "+%Y%m%d") --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                }
                //Create manifest for pytorch-base:cuda13-* and pytorch-base (since Cuda13 is latest) from existing tags. 
                sh 'podman manifest create ucsb/pytorch-base:cuda13-latest'
                sh 'podman manifest add ucsb/pytorch-base:cuda13-latest docker://docker.io/ucsb/pytorch-base:cuda13-latest-aarch64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                sh 'podman manifest add ucsb/pytorch-base:cuda13-latest docker://docker.io/ucsb/pytorch-base:cuda13-latest-amd64 --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                retry(6){
                    sh 'podman manifest push ucsb/pytorch-base:cuda13-latest docker://docker.io/ucsb/pytorch-base:cuda13-latest --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                    sh 'podman manifest push ucsb/pytorch-base:cuda13-latest docker://docker.io/ucsb/pytorch-base:cuda13-v$(date "+%Y%m%d") --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                    sh 'podman manifest push ucsb/pytorch-base:cuda13-latest docker://docker.io/ucsb/pytorch-base:latest --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                    sh 'podman manifest push ucsb/pytorch-base:cuda13-latest docker://docker.io/ucsb/pytorch-base:v$(date "+%Y%m%d") --creds $DOCKER_HUB_CREDS_USR:$DOCKER_HUB_CREDS_PSW'
                }
            }
            post {
                always {
                    sh 'podman manifest rm ucsb/jupyter-base:latest || true'
                    sh 'podman manifest rm ucsb/scipy-base:latest || true'
                    sh 'podman manifest rm ucsb/pytorch-base:cuda12-latest || true'
                    sh 'podman manifest rm ucsb/pytorch-base:cuda13-latest || true'
                }
            }
        }
    }
    post {
        success {
            slackSend(username: 'jenkins', color: 'good', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} just finished successfull! (<${env.BUILD_URL}|Details>)")
        }
        failure {
            slackSend(username: 'jenkins', color: 'danger', message: "Uh Oh! Build ${env.JOB_NAME} ${env.BUILD_NUMBER} had a failure! (<${env.BUILD_URL}|Find out why>).")
        }
    }
}
