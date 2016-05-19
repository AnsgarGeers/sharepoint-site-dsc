Param (
    [Parameter(Mandatory=$true)] [ValidateNotNullorEmpty()] [string] $WebUrl,
    [Parameter(Mandatory=$true)] [ValidateNotNullorEmpty()] [string] $DataFile
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell"

Import-Module .\SharePointSiteDSC.psm1 -Force
Import-Module $DataFile -Force 

$web = Get-SPWeb -Identity $WebUrl

if($config -ne $null){
    try {
        Start-IABuilder -web $web -config $config
    } catch [Exception] {
        Write-Warning "Error Occurred"
        echo $_.Exception | Format-List -force
    }    
}

$web.Dispose();