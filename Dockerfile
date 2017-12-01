FROM nexus.informatik.haw-hamburg.de/tomcat:9-alpine

RUN apk update && apk add wget


#
# Install geoserver
# geoserver-manager does not support GS >2.9.x so don't just update it.
#
ENV GS_version=2.9.4
ENV JAI_version=1.3.1

RUN mkdir -p /opt

RUN wget --quiet -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/geoserver-$GS_version-bin.zip -O geoserver.zip; \
  unzip -q geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver; \
  rm /usr/local/tomcat/geoserver.zip


#
# install importer plugin
#
# Just needed for the gui, so it is disabled.
#RUN wget --quiet -c http://sourceforge.net/projects/geoserver/files/GeoServer/$GS_version/extensions/geoserver-$GS_version-importer-plugin.zip -O importer-plugin.zip; \
#  unzip -q -o importer-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib; \
#  rm /usr/local/tomcat/importer-plugin.zip


#
# Install Java Advanced Imaging API (JAI)
#
RUN wget --quiet -c https://github.com/jai-imageio/jai-imageio-core/releases/download/jai-imageio-core-$JAI_version/jai-imageio-core-$JAI_version.jar -P /usr/local/tomcat/lib
# add JAI startup command to geoserver start script
RUN sed -i '/-jar start.jar/ s/$/-Dorg.geotools.coverage.jaiext.enabled=true/' /opt/geoserver/bin/startup.sh


#
# Cleanup
#
# Overlay files and directories in resources/overlays if they exist
RUN rm -f /tmp/resources/overlays/README.txt && \
    if ls /tmp/resources/overlays/* > /dev/null 2>&1; then \
      cp -rf /tmp/resources/overlays/* /; \
    fi;

# Remove Tomcat manager, docs, and examples
RUN rm -rf $CATALINA_HOME/webapps/ROOT && \
    rm -rf $CATALINA_HOME/webapps/docs && \
    rm -rf $CATALINA_HOME/webapps/examples && \
    rm -rf $CATALINA_HOME/webapps/host-manager && \
    rm -rf $CATALINA_HOME/webapps/manager && \
    rm -rf /tmp/resources


#
# Startup
#
ENV JAVA_HOME /usr/
ENV JAVA_OPTS="-server -Xms2G -Xmx2G -XX:+UseParallelOldGC -XX:+UseParallelGC -XX:NewRatio=2 -XX:+AggressiveOpts -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled"

ENV GEOSERVER_HOME /opt/geoserver
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

EXPOSE 8080

ENTRYPOINT ["/opt/geoserver/bin/startup.sh"]
