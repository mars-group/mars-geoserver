
INSERT INTO gis(name,TileTable,SpatialTable) VALUES ('osm','tileosm_0','tileosm_0');
INSERT INTO gis(name,TileTable,SpatialTable) VALUES ('osm','tileosm_1','tileosm_1');
INSERT INTO gis(name,TileTable,SpatialTable) VALUES ('osm','tileosm_2','tileosm_2');

 CREATE TABLE tileosm_0 (location CHAR(64) NOT NULL ,data BYTEA,CONSTRAINT tileosm_0_PK PRIMARY KEY(location));
 CREATE TABLE tileosm_1 (location CHAR(64) NOT NULL ,data BYTEA,CONSTRAINT tileosm_1_PK PRIMARY KEY(location));
 CREATE TABLE tileosm_2 (location CHAR(64) NOT NULL ,data BYTEA,CONSTRAINT tileosm_2_PK PRIMARY KEY(location));

select AddGeometryColumn('tileosm_0','geom',4326,'MULTIPOLYGON',2);
select AddGeometryColumn('tileosm_1','geom',4326,'MULTIPOLYGON',2);
select AddGeometryColumn('tileosm_2','geom',4326,'MULTIPOLYGON',2);

CREATE INDEX IX_tileosm_0 ON tileosm_0 USING gist(geom) ;
CREATE INDEX IX_tileosm_1 ON tileosm_1 USING gist(geom) ;
CREATE INDEX IX_tileosm_2 ON tileosm_2 USING gist(geom) ;
