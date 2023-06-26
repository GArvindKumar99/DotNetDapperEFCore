
CREATE   PROCEDURE [dbo].LogoutUser
	-- Add the parameters for the stored procedure here	
	@UserId int,
	@Token varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	delete from UserAccessTokens where UserId=@UserId and Token = @Token
	select @@Rowcount
END
