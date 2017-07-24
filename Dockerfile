#--------- Generic stuff all our Dockerfiles should start with ------------
FROM nexus.informatik.haw-hamburg.de/tomcat:9

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip nfs-common


#
# Install geoserver
#
ENV GS_version=2.9.1

RUN wget --quiet -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/geoserver-$GS_version-bin.zip -O geoserver.zip; \
  unzip -q geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver; \
  rm /usr/local/tomcat/geoserver.zip

# install importer plugin
RUN wget --quiet -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/extensions/geoserver-$GS_version-importer-plugin.zip -O importer-plugin.zip; \
  unzip -q -o importer-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib; \
  rm /usr/local/tomcat/importer-plugin.zip


#
# Install Java Advanced Imaging API (JAI)
#
RUN wget --quiet -c https://github.com/jai-imageio/jai-imageio-core/releases/download/jai-imageio-core-1.3.1/jai-imageio-core-1.3.1.jar -P /usr/local/tomcat/lib
# add JAI startup command to geoserver start script
RUN sed -i '/-jar start.jar/ s/$/-Dorg.geotools.coverage.jaiext.enabled=true/' /opt/geoserver/bin/startup.sh


#
# copy start script
#
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh


#
# Startup
#
ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/
ENV JAVA_OPTS="-server -Xms2G -Xmx2G -XX:+UseParallelOldGC -XX:+UseParallelGC -XX:NewRatio=2 -XX:+AggressiveOpts -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled"

EXPOSE 8080
CMD ["/entrypoint.sh"]
