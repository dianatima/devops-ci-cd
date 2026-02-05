pipeline {
  agent { label 'kaniko' }

  environment {
    ECR = credentials('ECR_URI_TEXT')
    HELM_REPO_URL = 'git@github.com:org/helm-repo.git'
    HELM_REPO_CREDENTIALS_ID = 'helm-repo-ssh'
    IMAGE_TAG = "${env.GIT_COMMIT.take(7)}"
    VALUES_FILE = 'charts/django-app/values.yaml'
  }

  options { timestamps() }

  stages {
    stage('Build & Push Image to ECR') {
      steps {
        container('kaniko') {
          sh """
            /kaniko/executor \
              --destination=${ECR}:${IMAGE_TAG} \
              --context=`pwd` \
              --dockerfile=Dockerfile \
              --snapshotMode=redo \
              --cache=true
          """
        }
      }
    }

    stage('Update Helm values.yaml in helm-repo') {
      steps {
        sshagent (credentials: [HELM_REPO_CREDENTIALS_ID]) {
          sh """
            rm -rf helm-repo && git clone ${HELM_REPO_URL} helm-repo
            cd helm-repo

            REPO_ESC=$(printf '%s\n' "${ECR}" | sed -e 's/[\\\/&]/\\\\&/g')
            sed -i.bak -E "s|(^\\s*repository:\\s*).*$|\\1\"${REPO_ESC}\"|g" ${VALUES_FILE}
            sed -i.bak -E "s|(^\\s*tag:\\s*).*$|\\1\"${IMAGE_TAG}\"|g" ${VALUES_FILE}
            rm -f ${VALUES_FILE}.bak

            git add ${VALUES_FILE}
            git -c user.name='jenkins' -c user.email='jenkins@local' commit -m "ci: update image to ${IMAGE_TAG}"
            git push origin main
          """
        }
      }
    }
  }
}