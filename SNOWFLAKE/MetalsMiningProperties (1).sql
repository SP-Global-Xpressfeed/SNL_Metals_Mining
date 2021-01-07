/***********************************************************************************************
Returns Comparables For Properties Within Thailand By Commodity, Stage, Mining And Processing Methods

Packages Required:
SNL Financial Metals & Mining Economics Data Feed

Universal Identifiers:
22_CountryName
23_GlobalRegion

Primary Columns Used:
1_PropertyID
3_SNLDataSourcePeriod
14_Commodity

Database_Type:
SNOWFLAKE

Query_Version:
V1

Query_Added_Date:
06/01/2021

DatasetKey:
19

The following sample query returns comparables for properties within Thailand by commodity, stage, mining and processing methods, etc.

***********************************************************************************************/

SELECT 
SNL_MMPROPERTIES_GENERAL."2_PropertyName",
SNL_MMPROPERTIES_GENERAL."1_PropertyID",
SNL_MMPROPERTIES_GENERAL."31_PrimaryCommodity",
SNL_MMPROPERTIES_GENERAL."23_GlobalRegion",
SNL_MMPROPERTIES_GENERAL."21_State/Province",
SNL_MMPROPERTIES_GENERAL."22_CountryName",
SNL_MMPROPERTIES_GENERAL."14_ListofCommodities",
SNL_MMPROPERTIES_GENERAL."4_DevelopmentStage",
SNL_MMPROPERTIES_GENERAL."5_ActivityStatus",
SNL_MMPROPERTIES_GENERAL."11_MineType1",
SNL_MMPROPERTIES_GENERAL."12_MineType2",
SNL_MMPROPERTIES_ORECAPACITY."13_MiningMethods",
SNL_MMPROPERTIES_ORECAPACITY."14_ProcessingMethods",
SNL_MMPROPERTIES_ORECAPACITY."6_MillCapacity-tonnes/year",
SNL_MMPROPERTIES_TONNAGEANDVOLUME."4_AsOfDate",
SNL_MMPROPERTIES_TONNAGEANDVOLUME."16_Commodity",
SNL_MMPROPERTIES_TONNAGEANDVOLUME."3_SNLDataSourcePeriod",
SNL_MMPROPERTIES_TONNAGEANDVOLUME."21_In-SituValue:Reserves&Resources",
SNL_MMPROPERTIES_TONNAGEANDVOLUME."9_Reserves&Resources:OreTonnage",
SNL_MMPROPERTIES_OWNER."8_OwnerName",
SNL_MMPROPERTIES_OWNER."18_OwnerMarketCapitalization",
SNL_MMPROPERTIES_OWNER."26_OwnerWorkingCapital",
SNL_MMPROPERTIES_OFFERINGS."6_Description",
SNL_MMPROPERTIES_OFFERINGS."5_DateAnnounced",
SNL_MMPROPERTIES_OFFERINGS."16_UseofProceeds",
SNL_MMPROPERTIES_OFFERINGS."9_Amount"

FROM SNL_MMPROPERTIES_GENERAL
LEFT JOIN SNL_MMPROPERTIES_ORECAPACITY ON SNL_MMPROPERTIES_ORECAPACITY."1_PropertyID" = SNL_MMPROPERTIES_GENERAL."1_PropertyID"
LEFT JOIN (SELECT MAX("3_SNLDataSourcePeriod") AS "3_SNLDataSourcePeriod", "1_PropertyID" FROM SNL_MMPROPERTIES_TONNAGEANDVOLUME GROUP BY "1_PropertyID") AS TAV_LATEST ON TAV_LATEST."1_PropertyID" = SNL_MMPROPERTIES_GENERAL."1_PropertyID"
LEFT JOIN SNL_MMPROPERTIES_TONNAGEANDVOLUME ON SNL_MMPROPERTIES_TONNAGEANDVOLUME."1_PropertyID" = TAV_LATEST."1_PropertyID" AND SNL_MMPROPERTIES_TONNAGEANDVOLUME."3_SNLDataSourcePeriod" = TAV_LATEST."3_SNLDataSourcePeriod" AND SNL_MMPROPERTIES_TONNAGEANDVOLUME."16_Commodity" = SNL_MMPROPERTIES_GENERAL."31_PrimaryCommodity"
LEFT JOIN SNL_MMPROPERTIES_OWNER ON SNL_MMPROPERTIES_OWNER."1_PropertyID" = SNL_MMPROPERTIES_GENERAL."1_PropertyID" AND SNL_MMPROPERTIES_OWNER."7_RankforMiningOwners" = 1
LEFT JOIN SNL_MMPROPERTIES_OFFERINGS ON SNL_MMPROPERTIES_OFFERINGS."1_PropertyID" = SNL_MMPROPERTIES_GENERAL."1_PropertyID" AND SNL_MMPROPERTIES_OFFERINGS."14_Commodity" = SNL_MMPROPERTIES_TONNAGEANDVOLUME."16_Commodity" AND SNL_MMPROPERTIES_OFFERINGS."3_MiningOfferingRankDescription" = 'Financing 1'
WHERE 1=1
AND SNL_MMPROPERTIES_GENERAL."1_PropertyID" NOT LIKE '%sp'
AND SNL_MMPROPERTIES_GENERAL."23_GlobalRegion" = 'Asia-Pacific'
AND SNL_MMPROPERTIES_GENERAL."22_CountryName" = 'Thailand'

ORDER BY
SNL_MMPROPERTIES_GENERAL."2_PropertyName";