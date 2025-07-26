FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Define JMeter version and paths
ENV JMETER_VERSION=5.6.3
ENV JMETER_HOME=/opt/jmeter
ENV PATH=$JMETER_HOME/bin:$PATH

# Install dependencies: Java, wget, curl, unzip, python3, Google Cloud SDK
RUN apt-get update && \
    apt-get install -y openjdk-11-jre wget unzip python3 curl lsb-release gnupg && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-474.0.0-linux-x86_64.tar.gz && \
    tar -xzf google-cloud-sdk-474.0.0-linux-x86_64.tar.gz -C /opt && \
    /opt/google-cloud-sdk/install.sh --quiet && \
    ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    rm google-cloud-sdk-474.0.0-linux-x86_64.tar.gz


# Download and extract Apache JMeter into /opt/jmeter
RUN wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
    mv /opt/apache-jmeter-${JMETER_VERSION} ${JMETER_HOME} && \
    rm apache-jmeter-${JMETER_VERSION}.tgz

# copy custom plugins 
COPY plugins/*.jar $JMETER_HOME/lib/ext/

# Create directories for tests and reports
RUN mkdir -p /jmeter-tests /jmeter-reports

WORKDIR /jmeter-tests


# to open a bash shell
CMD ["/bin/bash"]
