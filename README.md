# maui-profiling

Repository for building MAUI apps over time using different versions -- for installing & profiling.

## Results

These numbers were measured with preinstalled apps with `scripts\profile.ps1` on a Pixel 5 device running Android 12.

| Application        | Mode | Framework | Time(ms) |
|------------------- |------|-----------| --------:|
| XamarinAndroidApp  |  JIT |   Xamarin |    334.1 |
| XamarinAndroidApp  |  AOT |   Xamarin |    306.5 |
| dotnet new android |  JIT |  MAUI P10 |    265.4 |
| dotnet new android |  AOT |  MAUI P10 |    210.5 |
| dotnet new android |  JIT |  MAUI P11 |    269.4 |
| dotnet new android |  AOT |  MAUI P11 |    197.4 |
| dotnet new android |  JIT |  MAUI P12 |    260.9 |
| dotnet new android |  AOT |  MAUI P12 |    184.5 |
| XamarinFormsBlank  |  JIT |   Xamarin |    767.9 |
| XamarinFormsBlank  |  AOT |   Xamarin |    498.6 |
| XamarinFormsFlyout |  JIT |   Xamarin |   1369.5 |
| XamarinFormsFlyout |  AOT |   Xamarin |    817.7 |
| dotnet new maui    |  JIT |  MAUI P10 |   1078.0 |
| dotnet new maui    |  AOT |  MAUI P10 |    683.9 |
| dotnet new maui    |  JIT |  MAUI P11 |   1072.6 |
| dotnet new maui    |  AOT |  MAUI P11 |    677.4 |
| dotnet new maui    |  JIT |  MAUI P12 |   1013.8 |
| dotnet new maui    |  AOT |  MAUI P12 |    648.9 |
| PoolMath           |  JIT |   Xamarin |   2187.5 |
| PoolMath           |  AOT |   Xamarin |   1609.6 |
| PoolMath           |  JIT |  MAUI P11 |   3012.2 |
| PoolMath           |  AOT |  MAUI P11 |   2473.8 |

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