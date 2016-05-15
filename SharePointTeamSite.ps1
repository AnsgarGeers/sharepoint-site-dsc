Param (
    [Parameter(Mandatory=$true)] [ValidateNotNullorEmpty()] [string] $SiteUrl,
    [Parameter(Mandatory=$true)] [ValidateNotNullorEmpty()] [string] $DataFile
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell"

Import-Module .\SharePointTeamSite.psm1 -Force
Import-Module $DataFile -Force 

$site = Get-SPSite -Identity $SiteUrl
$web = $site.OpenWeb()

if($config -ne $null){
    Start-IABuilder -web $web -config $config
}

$web.Dispose();
$site.Dispose();