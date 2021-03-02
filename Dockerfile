FROM jenkins/jnlp-slave

USER 0

RUN    apt-get update \
    && apt-get install -y --no-install-recommends \
            gcc make build-essential libssl-dev zlib1g-dev libbz2-dev \
            libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
            libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev libsnappy-dev \
            zip rsync \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN    wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz \
    && tar xvf Python-3.6.8.tgz \
    && cd /tmp/Python-3.6.8 \
    && ./configure --enable-optimizations --with-ensurepip=install \
    && make -j8 \
    && make altinstall \
    && pip3.6 install pipenv

RUN    pip install --upgrade pip
RUN    pip install pandas
RUN    pip install awscli
RUN    pip install boto3 
RUN    pip install awswrangler

RUN    cd /tmp \
    && wget --no-verbose https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz \
    && tar zxvf openshift-origin-client-tools*.tar.gz \
    && mv /tmp/openshift-origin-client-tools*/oc /usr/local/bin/ \
    && rm -rf /tmp/openshift-origin-client-tools*

RUN    wget --no-verbose -O /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip \
    && unzip /tmp/sonar-scanner.zip -d /tmp/ \
    && mv /tmp/sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner \
    && ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/bin/sonar-scanner \
    && rm -rf /tmp/sonar-scanner.zip

USER jenkins
