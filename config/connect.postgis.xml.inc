<connect>
  <!-- value DBCP or JNDI -->
  <dstype value="DBCP"/>
  <!--   <jndiReferenceName value=""/>  -->
  <username value="docker" />
  <password value="docker" />
  <jdbcUrl value="jdbc:postgresql://marsgeoserver_postgis_1:5432/gis" />
  <driverClassName value="org.postgresql.Driver"/>
  <maxActive value="10"/>
  <maxIdle value="0"/>
</connect>