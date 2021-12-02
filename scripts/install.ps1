param
(
    [Parameter(Mandatory=$true)]
    [string] $apk,
    [string] $adb
)

$ErrorActionPreference = 'Stop'

# Input validation
if (-not $adb)
{
    $adb = 'C:\Program Files (x86)\Android\android-sdk\platform-tools\adb.exe'
    if (-not (Test-Path $adb))
    {
        # adb should be in $PATH on macOS
        $adb = 'adb'
    }
}

$package = [System.IO.Path]::GetFileNameWithoutExtension($apk)
$package = $package.Replace("-Signed", "")

Write-Host "adb uninstall $package"
& $adb uninstall $package
& $adb install $apk
