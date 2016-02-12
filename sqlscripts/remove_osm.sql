
drop index IX_tileosm_0;
drop index IX_tileosm_1;
drop index IX_tileosm_2;

select DropGeometryColumn('tileosm_0','geom');
select DropGeometryColumn('tileosm_1','geom');
select DropGeometryColumn('tileosm_2','geom');

drop table tileosm_0;
drop table tileosm_1;
drop table tileosm_2;

DELETE FROM gis WHERE name = 'osm' AND TileTable = 'tileosm_0' AND SpatialTable = 'tileosm_0'  ;
DELETE FROM gis WHERE name = 'osm' AND TileTable = 'tileosm_1' AND SpatialTable = 'tileosm_1'  ;
DELETE FROM gis WHERE name = 'osm' AND TileTable = 'tileosm_2' AND SpatialTable = 'tileosm_2'  ;
