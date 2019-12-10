USE [Test_TipaxPay]
GO

/****** Object:  UserDefinedFunction [dbo].[geometry2json]    Script Date: 12/10/2019 2:40:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[geometry2json]( @geo geometry)
 RETURNS nvarchar(MAX) AS
 BEGIN
 RETURN (
 '{' +
 (CASE @geo.STGeometryType()
 WHEN 'POINT' THEN
 '"type": "Point","coordinates":' +
 REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'POINT ',''),'(','['),')',']'),' ',',')
 WHEN 'POLYGON' THEN 
 '"type": "Polygon","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'POLYGON ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 WHEN 'MULTIPOLYGON' THEN 
 '"type": "MultiPolygon","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'MULTIPOLYGON ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 WHEN 'MULTIPOINT' THEN
 '"type": "MultiPoint","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'MULTIPOINT ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 WHEN 'LINESTRING' THEN
 '"type": "LineString","coordinates":' +
 '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'LINESTRING ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
 ELSE NULL
 END)
 +'}')
 END
GO


