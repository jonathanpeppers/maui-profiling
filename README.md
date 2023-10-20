# maui-profiling

Repository for building MAUI apps over time using different versions -- for installing & profiling.

## Results

These numbers were measured with preinstalled apps with `scripts\profile.ps1` on a Pixel 5 device running Android 12.

| Application        | Framework | JIT Time(ms) | Interpreter Time(ms) | Profiled AOT Time(ms) |
|------------------- |-----------| ------------:| --------------------:| ---------------------:|
| XamarinAndroidApp  |   Xamarin |        334.1 |                    - |                 306.5 |
| dotnet new android |  MAUI P10 |        265.4 |                    - |                 210.5 |
| dotnet new android |  MAUI P11 |        269.4 |                236.4 |                 197.4 |
| dotnet new android |  MAUI P12 |        260.9 |                235.2 |                 184.5 |
| dotnet new android |  MAUI P13 |        268.2 |                227.4 |                 198.4 |
| dotnet new android |  MAUI P14 |        244.1 |                210.1 |                 165.5 |
| dotnet new android |  MAUI RC1 |        259.7 |                205.7 |                 170.2 |
| dotnet new android |  MAUI RC2 |        257.8 |                209.9 |                 174.6 |
| dotnet new android |   MAUI GA |        262.7 |                217.6 |                 182.8 |
| dotnet new android | .NET 7 RC 2 |      261.6 |                177.2 |                 178.1 |
| dotnet new android | .NET 7 svc  |      276.3 |                192.7 |                 180.8 |
| dotnet new android | .NET 8 rtm  |      278.5 |                214.9 |                 180.4 |
| XamarinFormsBlank  |   Xamarin |        767.9 |                    - |                 498.6 |
| XamarinFormsFlyout |   Xamarin |       1369.5 |                    - |                 817.7 |
| dotnet new maui    |  MAUI P10 |       1078.0 |                    - |                 683.9 |
| dotnet new maui    |  MAUI P11 |       1072.6 |                867.9 |                 677.4 |
| dotnet new maui    |  MAUI P12 |       1013.8 |                860.7 |                 648.9 |
| dotnet new maui    |  MAUI P13 |       1063.1 |                864.4 |                 576.4 |
| dotnet new maui    |  MAUI P14 |        887.6 |                717.2 |                 469.9 |
| dotnet new maui    |  MAUI RC1 |       1278.9 |                933.4 |                 533.2 |
| dotnet new maui    |  MAUI RC2 |       1292.6 |                962.1 |                 563.7 |
| dotnet new maui    |   MAUI GA |       1411.8 |                978.0 |                 568.1 |
| dotnet new maui    | .NET 7 RC 2 |     1233.3 |                775.3 |                 545.4 |
| dotnet new maui    | .NET 7 svc  |     1283.1 |                798.6 |                 563.2 |
| dotnet new maui    | .NET 8 rtm  |     1362.8 |                888.8 |                 560.9 |
| dotnet new maui**  |  MAUI RC1 |        824.1 |                664.1 |                 437.1 |
| dotnet new maui**  |  MAUI RC2 |        837.6 |                678.3 |                 455.2 |
| dotnet new maui**  |   MAUI GA |        876.1 |                703.2 |                 464.2 |
| dotnet new maui**  | .NET 7 RC 2 |      839.3 |                607.9 |                 462.9 |
| dotnet new maui**  | .NET 7 svc  |      883.9 |                630.9 |                 490.5 |
| dotnet new maui**  | .NET 8 rtm  |      942.8 |                701.1 |                 482.4 |
| .NET Podcast       |  MAUI P14 |       1564.4 |               1177.5 |                1027.7 |
| .NET Podcast       |  MAUI RC1 |       1471.2 |               1139.9 |                 810.5 |
| .NET Podcast       |  MAUI RC2 |       1496.1 |               1148.5 |                 791.0 |
| .NET Podcast       |   MAUI GA |       1538.4 |               1171.1 |                 814.2 |
| .NET Podcast       | .NET 7 RC 2 |     1459.2 |                972.9 |                 759.7 |
| .NET Podcast       | .NET 7 svc  |     1501.3 |               1011.1 |                 787.2 |
| .NET Podcast       | .NET 8 rtm  |     1584.8 |               1071.9 |                 762.2 |

** _This is using the Preview 14 template built with MAUI RC 1. In RC 1,
the template changed to use the shell navigation pattern and
includes lots of built-in styles. It is a better template -- it just
has more "stuff" in it. The old template's times should be a direct
comparison between past releases._

NOTE: `.NET 7 svc` (servicing) is using .NET MAUI 7.0.96. I am using the same
device from above benchmarks, but it has had several Android updates and is
likely now aging. I reran one of these using the `.apk` and the number went from
545.4ms -> 558.8ms using the exact same device today.

* `XamarinAndroidApp`: Xamarin.Android Single View Application template from VS 2022
* `XamarinFormsFlyout`: Xamarin.Forms Flyout template from VS 2022
* `dotnet new android`: literally run this command
* `dotnet new maui`: literally run this command
* [.NET Podcast](https://github.com/microsoft/dotnet-podcasts)

In .NET 6, a project with `-p:UseInterpreter=true` includes
`libmono-component-hot_reload.so`. I recorded some startup times for
this, mainly as an experiment. This might be a view into what a
tiered-JIT could look like?

## FAQ

How to use `scripts\profile.ps1`?

If you don't easily know an apps package name & main activity:

1. You could open the `.apk` in Android Studio and look at the `AndroidManifest.xml` file.

1. Or run:

```powershell
> adb shell 'dumpsys window | grep mCurrentFocus'
mCurrentFocus=Window{f372400 u0 com.myapp.foo/crc64362beeb2c8180c73.MainActivity}
```

Then you run the script such as:

```powershell
> .\scripts\profile.ps1 -package com.myapp.foo -activity crc64362beeb2c8180c73.MainActivity
```

## Register ADB with Powershell

You may need to create a powershell alias for `adb`:

```powershell
Set-Alias adb "${env:ProgramFiles(x86)}\Android\android-sdk\platform-tools\adb.exe"
```

Or you can add the folder containing `adb.exe` to your `%PATH%`:

```powershell
if ($env:Path -NotMatch "Android\\android-sdk\\platform")
{
    write-host "Adding Android SDK Platform tools to path"
    $env:Path += ";${env:ProgramFiles(x86)}\Android\android-sdk\platform-tools"
}
```
(Or use the Windows environment variable menu)
