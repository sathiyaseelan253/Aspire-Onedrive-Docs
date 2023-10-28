
/*keywordID*/
declare @keywordID as bigint
set @keywordID = (select KeywordID from vrkeyword where keyword = 'Internal Reports')

/*Sequence*/
declare @sequence as bigint
set @sequence = (select max(Sequence)+1 from vrkeywordValues where keywordid = @keywordID)
IF NOT EXISTS(SELECT 1 FROM VRKeywordValues WHERE KeywordID = @keywordID and Value = 'Investor Signnow Attributes')
BEGIN
	insert into vrkeywordValues(KeywordID,Value,Sequence,IsDisplay) values(@keywordID,'Investor Signnow Attributes',@sequence,1)
END




