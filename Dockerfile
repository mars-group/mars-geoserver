#--------- Generic stuff all our Dockerfiles should start with ------------
FROM artifactory.mars.haw-hamburg.de:5000/tomcat:8.0

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip nfs-common ca-certificates curl
#RUN apt-get -y install vim


#
# Install Oracle JRE 7 for better performance (JRE 8 not supported yet)
# source: https://github.com/orgisuper/docker/blob/java7/oracle_jre/Dockerfile
#
ENV VERSION 7
ENV UPDATE 80
ENV BUILD 15

ENV JAVA_HOME /usr/lib/jvm/java-${VERSION}-oracle

RUN curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
	--header "Cookie: oraclelicense=accept-securebackup-cookie;" \
	http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"u"${UPDATE}"-b"${BUILD}"/jre-"${VERSION}"u"${UPDATE}"-linux-x64.tar.gz \
	| tar xz -C /tmp && \
	mkdir -p /usr/lib/jvm && mv /tmp/jre1.${VERSION}.0_${UPDATE} "${JAVA_HOME}" && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
	update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
	update-alternatives --set java "${JAVA_HOME}/bin/java" && \
	update-alternatives --set javaws "${JAVA_HOME}/bin/javaws"


ENV GS_version=2.8.2


#
# Install geoserver
#
RUN if [ ! -f geoserver.zip ]; then \
    wget -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/geoserver-$GS_version-bin.zip -O geoserver.zip; \
  fi; \
  unzip geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver; \
  rm /usr/local/tomcat/geoserver.zip

# install importer plugin
RUN if [ ! -f importer-plugin.zip ]; then \
    wget -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/extensions/geoserver-$GS_version-importer-plugin.zip -O importer-plugin.zip; \
  fi; \
  unzip -o importer-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib; \
  rm /usr/local/tomcat/importer-plugin.zip

ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/
ENV JAVA_OPTS="-server -Xms1G -Xmx1G -XX:+UseParallelOldGC -XX:+UseParallelGC -XX:NewRatio=2 -XX:+AggressiveOpts"


#
# Startup
#
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD /startup.sh

EXPOSE 8080
