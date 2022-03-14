<#
.SYNOPSIS

Runs adb commands to launch an Android application and time its
overall startup.

.DESCRIPTION

This will build & deploy the project, and by default launch the app 10
times. adb logcat messages are parsed and an average displayed.

.PARAMETER adb

Path to the adb executable. Will locate a default one installed by
Visual Studio 2019 and fall back to using the one found in $env:PATH.

.PARAMETER package

The package name of the app, found in AndroidManifest.xml. This value
is needed to launch or restart the app.

.PARAMETER activity

The full name of the main Activity, found in obj/**/android/AndroidManifest.xml.
This value is needed to launch or restart the app.

.PARAMETER iterations

The number of times to launch the app for profiling. Defaults to 10.

.EXAMPLE

PS> profile.ps1 -package com.companyname.HelloAndroid -activity crc6490bfc84a0f5dff7a.MainActivity

Launches the application 10 times and print the average time taken.

#>

param
(
    [Parameter(Mandatory=$true)]
    [string] $package,
    [Parameter(Mandatory=$true)]
    [string] $activity,
    [string] $adb,
    [int] $iterations = 10
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

# Clear some properties, so we don't accidentally hurt startup perf
& adb shell setprop debug.mono.log 0
& adb shell setprop debug.mono.profile 0
# Clear window animations
& adb shell settings put global window_animation_scale 0
& adb shell settings put global transition_animation_scale 0
& adb shell settings put global animator_duration_scale 0

# Do an initial launch and leave the app on screen
& adb shell am force-stop $package
& adb shell am start -n "$package/$activity" -W
Write-Host "Keeping the app on screen for 10 seconds..."
Start-Sleep -Seconds 10

# We need a large logcat buffer
& adb logcat -G 15M
& adb logcat -c
for ($i=0; $i -lt $iterations; $i++) {
    & adb shell am force-stop $package
    Start-Sleep -Seconds 1
    & adb shell am start -n "$package/$activity" -W
}

# Log message of the form:
# 12-12 09:08:36.974  1876  1898 I ActivityManager: Displayed com.xamarin.forms.helloforms/crc6450e568c951913723.MainActivity: +1s540ms

$log = & $adb logcat -d | Select-String -Pattern 'Activity.*Manager.+Displayed'
if ($log.Count -eq 0)
{
    Write-Error "No ActivityManager messages found"
}
if ($log.Count -ne $iterations)
{
    Write-Error "Expected $iterations ActivityManager messages, found $($log.Count)"
}

$sum = 0;
[System.Collections.ArrayList] $times = @()
foreach ($line in $log)
{
    if ($line -match "((?<seconds>\d+)s)?(?<milliseconds>\d+)ms(\s+\(total.+\))?$")
    {
        $seconds = [int]$Matches.seconds
        $milliseconds = [int]$Matches.milliseconds
        $time = $seconds * 1000 + $milliseconds
        $times.Add($time) > $null
        $sum += $time
        Write-Host $line
    }
    else
    {
        Write-Error "No timing found for line: $line"
    }
}
$mean = $sum / $log.Count
$variance = 0
if ($log.Count -ne 1)
{
    foreach ($time in $times)
    {
        $variance += ($time - $mean) * ($time - $mean) / ($log.Count - 1)
    }
}
$stdev = [math]::Sqrt($variance)
$stderr = $stdev / [math]::Sqrt($log.Count)

Write-Host "Average(ms): $mean"
Write-Host "Std Err(ms): $stderr"
Write-Host "Std Dev(ms): $stdev"