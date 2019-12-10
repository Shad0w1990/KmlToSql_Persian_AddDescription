USE [Test_TipaxPay]
GO

/****** Object:  UserDefinedFunction [dbo].[GetGeoJSON]    Script Date: 12/10/2019 2:40:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetGeoJSON] (@geo geography) /*this is your geography shape*/
RETURNS varchar(max)
WITH SCHEMABINDING /*this tells SQL SERVER that it is deterministic (helpful if you use it in a calculated column)*/
AS
BEGIN
/* Declare the return variable here*/
DECLARE @Result varchar(max)

/*Build JSON "geometry" element for geoJSON*/

SELECT  @Result = '"geometry":{' +
    CASE @geo.STGeometryType()
        WHEN 'POINT' THEN
            '"type": "Point","coordinates":' +
            REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'POINT ',''),'(','['),')',']'),' ',',')
        WHEN 'POLYGON' THEN 
            '"type": "Polygon","coordinates":' +
            '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'POLYGON ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
        WHEN 'MULTIPOLYGON' THEN 
            '"type": "MultiPolygon","coordinates":' +
            '[' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@geo.ToString(),'MULTIPOLYGON ',''),'(','['),')',']'),'], ',']],['),', ','],['),' ',',') + ']'
    ELSE NULL
    END
    +'}'

    /* Return the result of the function*/
    RETURN @Result

END
GO


