-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[CountOpenServiceCallsByAssignee]
	@AssigneeId int
AS
BEGIN
	
	select Cast((select count(*) as OpenServiceCallCount from ServiceCalls S where (@AssigneeId = (select top 1 RoleId from ServiceCallEvents
					where ServiceCallId = S.Id 
						order by Timestamp desc)
				or (-1 = (select top 1 RoleId from ServiceCallEvents
						where ServiceCallId = S.Id
						order by Timestamp desc) 
					and (select top 1 DepartmentId from ServiceCallEvents
						where ServiceCallId = S.Id
						order by Timestamp desc) in (select DepartmentId from DepartmentRoles where RoleId = @AssigneeId ))) and S.IsOpen =1)as bigint)
	
	
END



