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
| XamarinFormsBlank  |   Xamarin |        767.9 |                    - |                 498.6 |
| XamarinFormsFlyout |   Xamarin |       1369.5 |                    - |                 817.7 |
| dotnet new maui    |  MAUI P10 |       1078.0 |                    - |                 683.9 |
| dotnet new maui    |  MAUI P11 |       1072.6 |                867.9 |                 677.4 |
| dotnet new maui    |  MAUI P12 |       1013.8 |                860.7 |                 648.9 |
| dotnet new maui    |  MAUI P13 |       1063.1 |                864.4 |                 576.4 |
| dotnet new maui    |  MAUI P14 |        887.6 |                717.2 |                 469.9 |
| dotnet new maui    |  MAUI RC1 |       1278.9 |                933.4 |                 533.2 |
| dotnet new maui**  |  MAUI RC1 |        824.1 |                664.1 |                 437.1 |

** _This is using the Preview 14 template built with MAUI RC 1. In RC 1,
the template changed to use the shell navigation pattern and
includes lots of built-in styles. It is a better template -- it just
has more "stuff" in it. The old template's times should be a direct
comparison between past releases._

* `XamarinAndroidApp`: Xamarin.Android Single View Application template from VS 2022
* `XamarinFormsFlyout`: Xamarin.Forms Flyout template from VS 2022
* `dotnet new android`: literally run this command
* `dotnet new maui`: literally run this command

In .NET 6, a project with `-p:UseInterpreter=true` includes
`libmono-component-hot_reload.so`. I recorded some startup times for
this, mainly as an experiment. This might be a view into what a
tiered-JIT could look like?

### PoolMath

This is @Redth's app, which is not open source. Original numbers [here][poolmath].

Comparing numbers on a Google Pixel 4 (note that above numbers are Pixel 5).

|     Framework | JIT Time(ms) | Profiled AOT Time(ms) | Full AOT Time(ms) |
|---------------| ------------:| ---------------------:| -----------------:|
| Xamarin.Forms |       1892.7 |                 967.3 |             902.6 |
|      MAUI P13 |       1807.9 |                1245.8 |            1260.0 |

We think this app runs enough C# code on startup that recording custom
AOT profile would yield the best results. However, this is not
implemented yet in .NET 6. See [dotnet/runtime#56989][issue56989] for
tracking on this feature.

[poolmath]: https://gist.github.com/Redth/f2e5b2d6e952380f4619912d42b87ad2
[issue56989]: https://github.com/dotnet/runtime/issues/56989

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
