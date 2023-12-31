/****** Object:  StoredProcedure [dbo].[GetSignnowAttributes]    Script Date: 01-09-2023 16:56:03 ******/
DROP PROCEDURE IF EXISTS [dbo].[GetSignnowAttributes]
GO
/****** Object:  StoredProcedure [dbo].[GetSignnowAttributes]    Script Date: 01-09-2023 16:56:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetSignnowAttributes]
AS
BEGIN
    DECLARE @PivotSql NVARCHAR(MAX)
	DECLARE @finalstr NVARCHAR(max) 

    CREATE TABLE #tmpCols (colName VARCHAR(MAX))
    insert into #tmpCols
    SELECT distinct
        fieldname
    FROM VRSignNowAttrDetails

    declare @cols as varchar(max)
    select @cols
        = STUFF(
    (
        SELECT ',' + QUOTENAME(colName)
        from #tmpCols
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'),
    1   ,
    1   ,
    ''
               );
    WITH SignnowTbl
    AS (SELECT distinct
            SS.AccountID 'Account ID',
            ISNULL(VA.AcctName, '') 'Account Name',
            ISNULL(SD.FieldName, '') FieldName,
            ISNULL(SD.FieldValue, '') FieldValue
        FROM VRSignNowAttrDetails SD
            INNER JOIN
            (
                SELECT RANK() OVER (PARTITION BY AccountID ORDER BY TSVRSignSummary DESC) rowRank,
                       *
                FROM VRSignNowAttrSummary
            ) SS
                ON SS.SignSummaryID = SD.SignSummaryID
            INNER JOIN VRAccount VA
                ON VA.AcctID = SS.AccountID
                   AND VA.RecStatus = 1
        WHERE rowRank = 1
       )
    SELECT *
    INTO #TEMP
    FROM SignnowTbl

    SET @PivotSql
        = '
		SELECT
          *
		 FROM #TEMP
        PIVOT
        (
            MAX(FieldValue)
            FOR FieldName IN (' + @cols + ')
        ) P;'
    EXEC (@PivotSql)

	/*Build headers columns*/
	set @finalstr = REPLACE(REPLACE(@cols, '[', ''), ']', '')

	set @finalstr = 'Account ID'+',Account Name,'+@finalstr

	SELECT * FROM dbo.Split(@finalstr,',')
	
	IF OBJECT_ID('tempdb..#tmpCols') IS NOT NULL 
	DROP TABLE #tmpCols
END



--EXEC GetSignnowAttributes


GO
