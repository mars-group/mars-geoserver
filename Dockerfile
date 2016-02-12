#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM artifactory.mars.haw-hamburg.de:5000/tomcat:8.0

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip openjdk-7-jre-headless openjdk-7-jre nfs-common

ENV GS_version=2.8.2

# install geoserver
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



COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD /startup.sh

EXPOSE 8080
