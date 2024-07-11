FROM jenkins/jenkins:lts-jdk17
USER root

# Install necessary packages and tools
RUN apt-get update && \
    apt-get install -y curl && \
    curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
    apt-get install -y apt-transport-https && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install -y helm

RUN apt-get update && \
    apt-get install -y wget && \
    wget -P /tmp https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
    tar -xf /tmp/apache-maven-3.8.6-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.6/bin/mvn /usr/local/bin/mvn && \
    chown -R jenkins:jenkins /opt/apache-maven-3.8.6

RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    install -m 555 argocd-linux-amd64 /usr/local/bin/argocd && \
    rm argocd-linux-amd64

# Install Docker client
RUN apt-get update && \
    apt-get install -y docker.io

# Add Jenkins to Docker group
RUN usermod -aG docker jenkins

ENV MAVEN_HOME=/opt/apache-maven-3.6.3

ENV JAVA_OPTS="-Dhudson.udp=-1 -Djava.awt.headless=true -Dhudson.DNSMultiCast.disabled=true -Djenkins.install.runSetupWizard=false -Dhudson.security.csrf.CrumbFilter=severe"

ENV JENKINS_OPTS="--argumentsRealm.roles.user=admin --argumentsRealm.passwd.admin=admin --argumentsRealm.roles.admin=admin"

RUN jenkins-plugin-cli --plugins \
    docker-build-publish:latest \
    pipeline-groovy-lib:latest \
    junit:latest \
    workflow-scm-step:latest \
    jdk-tool:latest \
    github-branch-source:latest \
    pipeline-stage-view:latest \
    workflow-job:latest \
    blueocean-pipeline-editor:latest \
    workflow-aggregator:latest \
    scm-api:latest \
    matrix-auth:latest \
    workflow-support:latest \
    jakarta-mail-api:latest \
    apache-httpcomponents-client-4-api:latest \
    blueocean-git-pipeline:latest \
    trilead-api:latest \
    resource-disposer:latest \
    plugin-util-api:latest \
    email-ext:latest \
    blueocean-github-pipeline:latest \
    echarts-api:latest \
    jjwt-api:latest \
    authentication-tokens:latest \
    pipeline-stage-tags-metadata:latest \
    branch-api:latest \
    pipeline-rest-api:latest \
    jakarta-activation-api:latest \
    sse-gateway:latest \
    blueocean-pipeline-scm-api:latest \
    blueocean-personalization:latest \
    cloudbees-bitbucket-branch-source:latest \
    blueocean-core-js:latest \
    caffeine-api:latest \
    credentials-binding:latest \
    jenkins-design-language:latest \
    gradle:latest \
    pipeline-build-step:latest \
    blueocean-dashboard:latest \
    pipeline-stage-step:latest \
    htmlpublisher:latest \
    git-client:latest \
    pipeline-input-step:latest \
    workflow-basic-steps:latest \
    blueocean-web:latest \
    timestamper:latest \
    workflow-api:latest \
    pipeline-model-definition:latest \
    javax-activation-api:latest \
    pipeline-milestone-step:latest \
    credentials:latest \
    ldap:latest \
    build-timeout:latest \
    jaxb:latest \
    mailer:latest \
    pam-auth:latest \
    ant:latest \
    okhttp-api:latest \
    jquery3-api:latest \
    handy-uri-templates-2-api:latest \
    blueocean-rest:latest \
    workflow-durable-task-step:latest \
    durable-task:latest \
    github:latest \
    git:latest \
    blueocean-bitbucket-pipeline:latest \
    github-api:latest \
    ssh-credentials:latest \
    ssh-slaves:latest \
    workflow-cps:latest \
    pipeline-graph-analysis:latest \
    blueocean-autofavorite:latest \
    blueocean-display-url:latest \
    bootstrap5-api:latest \
    javax-mail-api:latest \
    font-awesome-api:latest \
    workflow-multibranch:latest \
    blueocean-events:latest \
    pipeline-github-lib:latest \
    antisamy-markup-formatter:latest \
    matrix-project:latest \
    blueocean-jwt:latest \
    blueocean-commons:latest \
    display-url-api:latest \
    blueocean-config:latest \
    blueocean-rest-impl:latest \
    bouncycastle-api:latest \
    pubsub-light:latest \
    jackson2-api:latest \
    command-launcher:latest \
    script-security:latest \
    blueocean:latest \
    cloudbees-folder:latest \
    token-macro \
    && chown -R jenkins:jenkins $JENKINS_HOME

ENV TZ=America/Santiago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER jenkins
