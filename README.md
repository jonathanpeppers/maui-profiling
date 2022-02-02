# maui-profiling

Repository for building MAUI apps over time using different versions -- for installing & profiling.

## Results

These numbers were measured with preinstalled apps with `scripts\profile.ps1` on a Pixel 5 device running Android 12.

| Application        | Framework | JIT Time(ms) | AOT Time(ms) |
|------------------- |-----------| ------------:| ------------:|
| XamarinAndroidApp  |   Xamarin |        334.1 |        306.5 |
| dotnet new android |  MAUI P10 |        265.4 |        210.5 |
| dotnet new android |  MAUI P11 |        269.4 |        197.4 |
| dotnet new android |  MAUI P12 |        260.9 |        184.5 |
| XamarinFormsBlank  |   Xamarin |        767.9 |        498.6 |
| XamarinFormsFlyout |   Xamarin |       1369.5 |        817.7 |
| dotnet new maui    |  MAUI P10 |       1078.0 |        683.9 |
| dotnet new maui    |  MAUI P11 |       1072.6 |        677.4 |
| dotnet new maui    |  MAUI P12 |       1013.8 |        648.9 |
| PoolMath           |   Xamarin |       2187.5 |       1609.6 |
| PoolMath           |  MAUI P11 |       3012.2 |       2473.8 |

* `XamarinAndroidApp`: Xamarin.Android Single View Application template from VS 2022
* `XamarinFormsFlyout`: Xamarin.Forms Flyout template from VS 2022
* `PoolMath`: @Redth's app
* `dotnet new android`: literally run this command
* `dotnet new maui`: literally run this command

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