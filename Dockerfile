#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM artifactory.mars.haw-hamburg.de:5000/tomcat:8.0

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip openjdk-7-jre-headless openjdk-7-jre nfs-common

# install geoserver
RUN if [ ! -f geoserver.zip ]; then \
  wget -c http://sourceforge.net/projects/geoserver/files/GeoServer/2.8.0/geoserver-2.8.0-bin.zip -O geoserver.zip; \
  fi; \
  unzip geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver; \
  rm /usr/local/tomcat/geoserver.zip

# install importer plugin
RUN if [ ! -f importer-plugin.zip ]; then \
 wget -c http://sourceforge.net/projects/geoserver/files/GeoServer/2.8.0/extensions/geoserver-2.8.0-importer-plugin.zip -O importer-plugin.zip; \
  fi; \
  unzip -o importer-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib; \
  rm /usr/local/tomcat/importer-plugin.zip

ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/
ENV JAVA_OPTS="-server -Xms48m -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:MaxPermSize=512m -XX:+UseParallelGC"

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD /startup.sh

EXPOSE 8080