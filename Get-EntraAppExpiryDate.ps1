
##########################################################################

#Get-EntraAppExpiryDate.ps1
#Author : Sujin Nelladath
#LinkedIn : https://www.linkedin.com/in/sujin-nelladath-8911968a/

##########################################################################

cls

# Connect to Microsoft Graph

Connect-MgGraph -Scopes "Application.Read.All" -NoWelcome

# Define expiration threshold

$thresholdDate = (Get-Date).AddDays(30)
$expiringApps = @()

try {

    $applications = Get-MgApplication

    foreach ($app in $applications) 
    {
        foreach ($credential in $app.PasswordCredentials) 
        {
            if ($credential.EndDateTime -and $credential.EndDateTime -lt $thresholdDate) 
            {
                $expiringApps += [PSCustomObject]@{
                    DisplayName     = $app.DisplayName
                    ExpiryDate      = $credential.EndDateTime
                    AppId           = $app.AppId
             
              }

            }
        }
    }

    if ($expiringApps.Count -gt 0) 

    {

        foreach ($entry in $expiringApps) 
        
        {
            
            Write-Host " '$($entry.DisplayName)' has a password credential expiring on $($entry.ExpiryDate)" -ForegroundColor Red
        }

    } 
    
    else 
    
    {
        Write-Host " No application credentials are expiring within the next 30 days." -ForegroundColor Green
    }
}

catch 

{
    Write-Host " An error occurred while retrieving application data: $($_.Exception.Message)" -ForegroundColor Yellow
}