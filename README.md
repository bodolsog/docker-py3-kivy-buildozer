# Docker-py3-kivy-buildozer

Docker image built for [kivy's buildozer](https://github.com/kivy/buildozer) with Android CrystaX NDK and python3 support.

## bildozer.spec

To enable py3 support your buildozer.spec need to contain `python3crystax` in requirements. CrystaX is downloaded on build image task and installed in `/opt/crystax-ndk-10.3.2/`. This location should be putted in `android.ndk_path` spec's variable.

```
# buildozer.spec

# (list) Application requirements
requirements = python3crystax,kivy

# (str) Android NDK directory (if empty, it will be automatically downloaded.)
android.ndk_path = /opt/crystax-ndk-10.3.2
```

### Additional

You can set `build_dir` to /home/kivy/ and use this location as Docker Volume to avoid re-download all dependencies each time.

```
# (str) Path to build artifact storage, absolute or relative to spec file
build_dir = /home/kivy/
```

## Usage:

```
$ cd [buildozer.spec location]
```

- Create volume for dependencies:
```
docker run --rm -it --name bankster-mobile --privileged -v $PWD:/src -v /dev/bus/usb:/dev/bus/usb -v buildozer:/home/kivy bodolsog/py3-kivy-buildozer:latest
```

- Get into container:
```
$ docker run --rm -it --privileged -v $PWD:/src -v /dev/bus/usb:/dev/bus/usb -v buildozer:/home/kivy bodolsog/py3-kivy-buildozer:latest
```

- Explaination:
  - `--rm` - remove container after run
  - `-v $PWD:/src ` - mount current directory as `/src` in container
  - `--privileged` and `-v /dev/bus/usb:/dev/bus/usb` are needed to allow communicate between container and usb-connected Android device
  - `-v buildozer:/home/kivy` - mount buildozer volume to keep downloaded dependencies
  - `bodolsog/py3-kivy-buildozer:latest` - image name

- run task in container (examples):
```
# buildozer adb -- devices
# buildozer android update
# buildoxer android debug deploy run logcat
```

# Note
Tested only with android for simple apps. Python3 support for buildozer and python-for-android are still in beta.

# Improvements and Pull Request
Improvements and Pull Requests are welcome.