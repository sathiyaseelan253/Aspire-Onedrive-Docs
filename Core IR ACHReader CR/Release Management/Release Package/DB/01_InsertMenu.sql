/*Insert VRmenu*/
DECLARE @Sequence AS BIGINT = (SELECT MAX(SortingNum) FROM VRMenu)
IF NOT EXISTS(SELECT 1 FROM VRMenu WHERE MenuID = '2.4.9')
BEGIN
	INSERT INTO VRMenu(MenuID,MenuName,Href,IsDisplay,SortingNum) VALUES('2.4.9','ACH Reader','../../Admin/Common/ACHReader.aspx',1,@Sequence)
END

DECLARE @GroupID AS BIGINT = (SELECT GroupID FROM VRGroupUser WHERE UserID = 'vantage')
IF NOT EXISTS(SELECT 1 FROM VRUserRights WHERE MenuID = '2.4.9' AND GroupID = @GroupID AND UserID = 'vantage')
BEGIN
	INSERT INTO VRUserRights(GroupID,UserID,MenuID,RightsValue) VALUES(@GroupID,'vantage','2.4.9',4)
END

