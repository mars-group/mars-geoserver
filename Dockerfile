#--------- Generic stuff all our Dockerfiles should start with ------------
FROM artifactory.mars.haw-hamburg.de:5000/tomcat:8.0

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip nfs-common ca-certificates python-pip


#
# Install Oracle JDK 7 for better performance (JDK 8 not supported yet)
# source: https://github.com/orgisuper/docker/blob/java7/oracle_jdk/Dockerfile
#
ENV VERSION 7
ENV UPDATE 80
ENV BUILD 15

ENV JAVA_HOME /usr/lib/jvm/java-$VERSION-oracle

RUN curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"u"${UPDATE}"-b"${BUILD}"/jdk-"${VERSION}"u"${UPDATE}"-linux-x64.tar.gz \
  | tar xz -C /tmp && \
  mkdir -p /usr/lib/jvm && mv /tmp/jdk1.${VERSION}.0_$UPDATE "${JAVA_HOME}" && \
  apt-get autoclean && apt-get --purge -y autoremove && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
  update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
  update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
  update-alternatives --set java "${JAVA_HOME}/bin/java" && \
  update-alternatives --set javaws "${JAVA_HOME}/bin/javaws" && \
  update-alternatives --set javac "${JAVA_HOME}/bin/javac"


#
# Install Java Advanced Imaging API (JAI)
#
COPY install-JAI.sh /install-JAI.sh
RUN chmod +x /install-JAI.sh
RUN /install-JAI.sh && rm /install-JAI.sh

ENV _POSIX2_VERSION=199209


#
# Install JCE policy jars
#
COPY jce_policy/local_policy.jar /usr/lib/jvm/java-7-oracle/jre/lib/security/
COPY jce_policy/US_export_policy.jar /usr/lib/jvm/java-7-oracle/jre/lib/security/


#
# Install geoserver
#
ENV GS_version=2.8.2

RUN wget --quiet -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/geoserver-$GS_version-bin.zip -O geoserver.zip; \
  unzip -q geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver; \
  rm /usr/local/tomcat/geoserver.zip

# install importer plugin
RUN wget --quiet -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/extensions/geoserver-$GS_version-importer-plugin.zip -O importer-plugin.zip; \
  unzip -q -o importer-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib; \
  rm /usr/local/tomcat/importer-plugin.zip

# copy start script
COPY startup.sh /
RUN chmod +x /startup.sh


#
# Eureka connection
#
RUN pip install --index-url=https://artifactory.mars.haw-hamburg.de/artifactory/api/pypi/python_cache_and_private_repos/simple mars-3rd-party-service-wrapper
COPY entrypoint.py /
RUN chmod +x /entrypoint.py


#
# Startup
#
ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/
ENV JAVA_OPTS="-server -Xms2G -Xmx2G -XX:+UseParallelOldGC -XX:+UseParallelGC -XX:NewRatio=2 -XX:+AggressiveOpts -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled -XX:MaxPermSize=1024M"

EXPOSE 8080
CMD ["/entrypoint.py"]
