# maui-profiling

Repository for building MAUI apps over time using different versions -- for installing & profiling.

## Results

These numbers were measured with preinstalled apps with `scripts\profile.ps1` on a Pixel 5 device running Android 12.

|   App    | Mode | Framework | Time(ms) |
|--------- |------|-----------| --------:|
| PoolMath |  JIT |   Xamarin |   2187.5 |
| PoolMath |  AOT |   Xamarin |   1609.6 |
| PoolMath |  JIT |  MAUI P11 |   3107.9 |
| PoolMath |  AOT |  MAUI P11 |   2549.9 |

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