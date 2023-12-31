/****** Object:  StoredProcedure [dbo].[pub_FinancialCompanyDataGet3]    Script Date: 3/15/2023 10:53:32 AM ******/
DROP PROCEDURE IF EXISTS [dbo].[pub_FinancialCompanyDataGet3]
GO
/****** Object:  StoredProcedure [dbo].[pub_FinancialCompanyDataGet3]    Script Date: 3/15/2023 10:53:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[pub_FinancialCompanyDataGet3]    
(                
@MgmtCompanyId bigint  ,        
@FinancialType  varchar(100),      
@FromDate  datetime,        
@ToDate  datetime,      
@ViewType  varchar(10),
@EndMonth INT    
)                
As                
Begin                         
      
  declare @ViewTypeValue as int        
  declare @Recstatus as varchar(10)        
  declare @Value as varchar(50)        
  declare @Count as int        
  declare @SummaryCount as int        
  declare @Month as datetime        
  declare @financialsummaryid as bigint
  declare @SummaryIds as  varchar(8000)    
  declare @MainQry as varchar(Max)        
  declare @SubQry1 as varchar(Max)        
  declare @SubQry2 as varchar(Max)        
 
       
       
   
  IF @ViewType='Monthly'  
  BEGIN  
  SET @ViewTypeValue=1
    select FundID,FundName,FinancialType,KPIName,FinancialYear,
  [31-Jan],[28-Feb],[31-Mar],[30-Apr],
  [31-May],[30-Jun],[31-Jul],[31-Aug],
  [30-Sep],[31-Oct],[30-Nov],[31-Dec] from(
  select F.FundID,F.FundName,KV.Value as FinancialType,FMS.ElementName as KPIName,FinancialYear,
  Month1 as [31-Jan],Month2 as [28-Feb],Month3 as [31-Mar],Month4 as [30-Apr],
  Month5 as [31-May],Month6 as [30-Jun],Month7 as [31-Jul],Month8 as [31-Aug],
  Month9 as [30-Sep],Month10 as [31-Oct],Month11 as [30-Nov],Month12 as [31-Dec],
  case when (Month1 is null and Month2 is null and Month3 is null and Month4 is null and Month5 is null and
  Month6 is null and Month7 is null and Month8 is null and Month9 is null and Month10 is null and
  Month11 is null and Month12 is null) then 0 else 1 end as filterdata
  from VRFinancialSummary FS
inner join VRFinancialDetails FD on FS.FinancialSummaryId = FD.FinancialSummaryId
inner join vwFinancialMatrixSetup FMS on FMS.ElementId=FD.ElementId and FS.MgmtCompanyId=FMS.mgmtcompanyid
inner join VRFund F on F.FundID =FS.MgmtCompanyId and F.RecStatus=1
left join VRKeywordValues KV on KV.KeywordValueID=FS.FinancialTypeId
where FS.RecStatus=1 and FinancialYear between  year(@FromDate) and year(@ToDate)
and FinancialTypeId = (case when @FinancialType = 0 then FinancialTypeId else @FinancialType end)
and F.FundID=(case when @MgmtCompanyId=0 then F.FundID else @MgmtCompanyId end)
and FMS.HierarchyLevel <>1
)A Where filterdata = 1
order by FundName,KPIName,FinancialYear,FinancialType

  END  
  ELSE IF @ViewType='Quarterly'  
  BEGIN  
 SET @ViewTypeValue=2  
 select F.FundID,F.FundName,KV.Value as FinancialType,FMS.ElementName as KPIName,FinancialYear,
  Q1,Q2,Q3,Q4
  from VRFinancialSummary FS
inner join VRFinancialDetails FD on FS.FinancialSummaryId = FD.FinancialSummaryId
inner join vwFinancialMatrixSetup FMS on FMS.ElementId=FD.ElementId and FS.MgmtCompanyId=FMS.mgmtcompanyid
inner join VRFund F on F.FundID =FS.MgmtCompanyId and F.RecStatus=1
left join VRKeywordValues KV on KV.KeywordValueID=FS.FinancialTypeId
where FS.RecStatus=1 and FinancialYear between  year(@FromDate) and year(@ToDate)
and FinancialTypeId = (case when @FinancialType = 0 then FinancialTypeId else @FinancialType end)
and F.FundID=(case when @MgmtCompanyId=0 then F.FundID else @MgmtCompanyId end)
and FMS.HierarchyLevel <>1
order by F.FundName,FMS.ElementName,FinancialYear,KV.Value
  END  
  ELSE   IF @ViewType='Annual'
  BEGIN  
 SET @ViewTypeValue=3  
 select F.FundID,F.FundName,KV.Value as FinancialType,FMS.ElementName as KPIName,FinancialYear,
 Annual
  from VRFinancialSummary FS
inner join VRFinancialDetails FD on FS.FinancialSummaryId = FD.FinancialSummaryId
inner join vwFinancialMatrixSetup FMS on FMS.ElementId=FD.ElementId and FS.MgmtCompanyId=FMS.mgmtcompanyid
inner join VRFund F on F.FundID =FS.MgmtCompanyId and F.RecStatus=1
left join VRKeywordValues KV on KV.KeywordValueID=FS.FinancialTypeId
where FS.RecStatus=1 and FinancialYear between  year(@FromDate) and year(@ToDate)
and FinancialTypeId = (case when @FinancialType = 0 then FinancialTypeId else @FinancialType end)
and F.FundID=(case when @MgmtCompanyId=0 then F.FundID else @MgmtCompanyId end)
and FMS.HierarchyLevel <>1
order by F.FundName,FMS.ElementName,FinancialYear,KV.Value
  END
   ELSE   IF @ViewType='All'
  BEGIN  
 SET @ViewTypeValue=0
 select FundID,FundName,FinancialType,KPIName,FinancialYear,
  [31-Jan],[28-Feb],[31-Mar],[30-Apr],
  [31-May],[30-Jun],[31-Jul],[31-Aug],
  [30-Sep],[31-Oct],[30-Nov],[31-Dec], Q1,Q2,Q3,Q4,
  Annual from(
 select F.FundID,F.FundName,KV.Value as FinancialType,FMS.ElementName as KPIName,FinancialYear,
  Month1 as [31-Jan],Month2 as [28-Feb],Month3 as [31-Mar],Month4 as [30-Apr],
  Month5 as [31-May],Month6 as [30-Jun],Month7 as [31-Jul],Month8 as [31-Aug],
  Month9 as [30-Sep],Month10 as [31-Oct],Month11 as [30-Nov],Month12 as [31-Dec],
  Q1,Q2,Q3,Q4,
  Annual,
  case when (Month1 is null and Month2 is null and Month3 is null and Month4 is null and Month5 is null and
  Month6 is null and Month7 is null and Month8 is null and Month9 is null and Month10 is null and
  Month11 is null and Month12 is null and Q1 is null and Q2 is null and Q3 is null and Q4 is null and
  Annual is null) then 0 else 1 end as filterdata
  from VRFinancialSummary FS
inner join VRFinancialDetails FD on FS.FinancialSummaryId = FD.FinancialSummaryId
inner join vwFinancialMatrixSetup FMS on FMS.ElementId=FD.ElementId and FS.MgmtCompanyId=FMS.mgmtcompanyid
inner join VRFund F on F.FundID =FS.MgmtCompanyId and F.RecStatus=1
left join VRKeywordValues KV on KV.KeywordValueID=FS.FinancialTypeId
where FS.RecStatus=1 and FinancialYear between  year(@FromDate) and year(@ToDate)
and FinancialTypeId = (case when @FinancialType = 0 then FinancialTypeId else @FinancialType end)
and F.FundID=(case when @MgmtCompanyId=0 then F.FundID else @MgmtCompanyId end)
and FMS.HierarchyLevel <>1
)A Where filterdata = 1
order by FundName,KPIName,FinancialYear,FinancialType
  END
   
      

End

GO
