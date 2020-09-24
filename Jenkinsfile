pipeline {
      agent {
        kubernetes {
          defaultContainer 'docker'
          yaml """
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        some-label: some-label-value
    spec:
      containers:
      - name: docker
        image: kvalitetsit/docker:latest
        command:
        - cat
        tty: true
        volumeMounts:
          - name: docker-sock
            mountPath: /var/run/docker.sock
      - name: helm
        image: alpine/helm:3.2.3
        command:
        - cat
        tty: true
        volumeMounts:
          - name: docker-sock
            mountPath: /var/run/docker.sock
      - name: git
        image: alpine/git:v2.26.2
        command:
        - cat
        tty: true
        volumeMounts:
          - name: docker-sock
            mountPath: /var/run/docker.sock
      volumes:
      - name: docker-sock
        hostPath:
          path: /var/run/docker.sock
    """
        }
      }

    stages {
        stage('Initialize') {
            steps{
                script {
                    currentBuild.displayName = "$currentBuild.displayName-${env.GIT_COMMIT}"
                }
            }
        }
        stage('Build Helm - Argo apps of apps') {
            steps {
                script {
                    if (env.TAG_NAME != null && env.TAG_NAME.matches("^v[0-9]*\\.[0-9]*\\.[0-9]*")) {

                        container('helm') {
                            sh 'helm package argoApps --app-version ' + env.TAG_NAME.substring(1) + ' --version ' + env.TAG_NAME.substring(1)
                        }

                        checkout([$class: 'GitSCM',
                        branches: [[name: '*/master']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'helm-repo']],
                        submoduleCfg: [],
                        userRemoteConfigs: [[credentialsId: 'github', url: 'git@github.com:KvalitetsIT/helm-repo.git']]])

                        container('helm') {
                            dir('helm-repo'){
                                sh """
                                mkdir -p ${WORKSPACE}/helm-repo/argoApps/
                                mv ${WORKSPACE}/argoApps-* ${WORKSPACE}/helm-repo/argoApps/
                                helm repo index . --url https://raw.githubusercontent.com/KvalitetsIT/helm-repo/master/
                                ls -l
                                """
                            }
                        }

                        container('git') {
                            withCredentials([sshUserPrivateKey(credentialsId: 'github', keyFileVariable: 'KEY')]) {
                                dir('helm-repo'){
                                    sh """
                                    git config --global user.email "developer@kvalitetsit.dk"
                                    git config --global user.name "Jenkins"
                                    git status
                                    git add .
                                    git commit -m "New argoApps Helm chart"
                                    GIT_SSH_COMMAND="ssh -i $KEY -o StrictHostKeyChecking=no" git push origin HEAD:master
                                    """
                                }
                            }
                        }
                    }else{
                        container('helm') {
                            sh 'helm package argoApps'
                        }
                    }
                }
            }
        }
    }
}
