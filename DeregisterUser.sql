CREATE PROCEDURE [dbo].[DeregisterUser]
    -- Add the parameters for the stored procedure here
    @UserId int
 
AS
BEGIN
    DECLARE @Mobile NVARCHAR(MAX), @UserOTPId INT
    
    If @UserId > 0 AND @UserId IS NOT NULL
    BEGIN

        SET @Mobile = (SELECT Mobile FROM UserInfo WHERE Id = @UserId)
        SET @UserOTPId = (SELECT Id FROM UserOTP WHERE Mobile = @Mobile)
        DELETE FROM UserOTP WHERE Id = @UserOTPId

        --Delete from Userinfo
        DELETE FROM UserInfo WHERE Id = @UserId

    END

END
