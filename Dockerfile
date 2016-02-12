#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM artifactory.mars.haw-hamburg.de:5000/tomcat:8.0

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip openjdk-7-jre-headless openjdk-7-jre nfs-common
#RUN apt-get -y install vim

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

# install imagemosaic plugin
#RUN if [ ! -f imagemosaic-jdbc-plugin.zip ]; then \
# wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GS_version/extensions/geoserver-$GS_version-imagemosaic-jdbc-plugin.zip -O imagemosaic-jdbc-plugin.zip; \
#  fi; \
#  unzip -o imagemosaic-jdbc-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib; \
#  rm /usr/local/tomcat/imagemosaic-jdbc-plugin.zip


#RUN docker cp osm.postgis.xml marsgeoserver_geoserver_1:/opt/geoserver/data_dir/coverages/
#RUN docker cp mapping.postgis.xml.inc marsgeoserver_geoserver_1:/opt/geoserver/data_dir/coverages/
#RUN docker cp connect.postgis.xml.inc marsgeoserver_geoserver_1:/opt/geoserver/data_dir/coverages/

#mkdir /opt/geoserver/sqlscripts
#java -jar /opt/geoserver/webapps/geoserver/WEB-INF/lib/gt-imagemosaic-jdbc-14.1.jar ddl -config /opt/geoserver/data_dir/coverages/osm.postgis.xml -spatialTNPrefix tileosm -pyramids 2 -statementDelim ";" -srs 4326 -targetDir sqlscripts


ENV GEOSERVER_HOME /opt/geoserver
ENV JAVA_HOME /usr/
ENV JAVA_OPTS="-server -Xms128m -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:MaxPermSize=1G -XX:+UseParallelGC"
#ENV JAVA_OPTS="-server -Xms1024m -Xmx1024m -XX:+UseParallelOldGC -XX:+UserParallelGC -XX:NewRatio=2 -XX:+AggressiveOpt"


COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD /startup.sh

EXPOSE 8080
