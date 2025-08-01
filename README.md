# [OpenMPT](https://openmpt.org) for Godot

These are bindings for [libopenmpt](https://github.com/OpenMPT/openmpt/tree/master/libopenmpt) (The library version of the playback engine of [OpenMPT](https://openmpt.org), the modtracker software) made for Godot which allows you to play almost any tracker module format (like .xm or .it or .s3m or even something like .umx aka the Unreal Engine 1 Music format) under the sun as a normal AudioStream (as if it was just a WAV or OGG file)

## Why?

Because my game uses mod-tracker music inspired by Deus-Ex, and it also makes looping and dynamic music easier.

## Where can I find a pre-built addon?

Just go to the prebuilt branch and use the download ZIP feature of Github, or use "Releases" on the side, extract it into your project and you're done!

If you want to take a look at a commit that's more recent, then you can download the addon as a CI build artifact from the Github workflow action.

## Documentation

For information on what functions you can use either look at the source code, or look at the in-editor docs for the types `AudioStreamMPT` and `AudioStreamPlaybackMPT`.

There is no official written documentation for the time being, but just the function names and parameter names should most likely be helpful enough; and if you know any amount of C++ the code should be pretty easy to parse.

## What platforms does it support?

In theory, all of them. In practice building for certain platforms sucks and so hasn't been tested. I have only tested Windows and Linux thus far. As for MacOS... I don't have a Mac neither do I have the money for one so unless someone else would like to volunteer to compile it and provide fixes if anything goes wrong on Mac, I can't test it myself. Blame Apple for having stupid licensing in regards to their system headers, otherwise cross-compilation probably wouldn't be that hard.

As for mobile platforms, I haven't tested them either because I don't make mobile games and iOS has a lot of the same issues as MacOS does (don't have an iPhone either). Android should probably work, but it hasn't been tested. (Just like with MacOS open an issue if you run into any problems)

## M1/Apple Silicon Compatibility

If you're using the pre-built binaries on Apple Silicon (M1/M2) Macs and experiencing crashes or the plugin not loading, this is likely due to dynamic library linking issues in the universal binaries. The addon includes a fix script to resolve these issues:

### Automatic Fix (Recommended)

The build process now automatically applies M1 compatibility fixes during CI/CD. If you're downloading from releases or CI artifacts, the binaries should work out of the box.

### Manual Fix (If needed)

If you're still experiencing issues, you can manually run the compatibility fix:

```bash
# Make the script executable (if not already)
chmod +x fix-m1-compatibility.sh

# Run the fix on your addon
./fix-m1-compatibility.sh path/to/your/project/addons/godot-openmpt
```

The script will:
- Fix install names to use proper relative paths
- Remove problematic build system rpaths
- Ensure proper linking for both Intel and ARM64 architectures
- Create backups of original binaries

### What causes the M1 issue?

The issue stems from how universal binaries are created during the build process. The individual Intel and ARM64 binaries may have hardcoded paths or incorrect install names that work on the build system but fail on end-user machines. This is particularly problematic on M1 Macs where the dynamic linker is more strict about library loading.

## How to build

This project uses CMake so it's recommended to use that (even for building godot-cpp as the library names are different and I had issues mixing SCons and CMake before).

It has been tested on Windows and Linux. MacOS might work but you're on your own (at least for now), open an issue if it has any problems and I'll try to address them or you can address them yourself in a PR (probably easier if you can, since I can't test things without a Mac).

### godot-cpp (both platforms)

If you're on Windows use the Visual Studio 2022 CMake integration; though you'll want to use CMake from a Visual Studio Developer Command Prompt terminal and probably not from Visual Studio itself (though you could, it's just probably easier to do it from a terminal).

Open the `custom-godotcpp-build` directory in the terminal. Here we'll use CMake with this as the source *and* the binary directory (this is required for the main build script to work).

There is an optional define called `GENERATE_DEBUG_SYMBOLS`, this is the reason we need a custom build script in the first place.
If you're developing and ran into an error in godot-cpp OR libopenmpt itself, feel free to turn it on. But if you're just building this for any other reason define it to be `OFF` (`-DGENERATE_DEBUG_SYMBOLS=OFF`).
Otherwise, the binaries will end up being pretty big (perhaps so big that Github won't even let you push the files anymore!), so use with caution.

You can run something like this: ``cmake . -G Ninja -DGENERATE_DEBUG_SYMBOLS=OFF -DCMAKE_BUILD_TYPE=<INSERT EITHER Release OR Debug HERE>``
Then run `ninja`, the generator we defined; which is recommended since it's fast and comes with VS:
``ninja``

If you want to build both `Release` and `Debug` versions you'll have to define the `CMAKE_BUILD_TYPE` for one of them, then delete all the extra CMake generated files (other than the `bin` and `gen` directories, do NOT delete `CMakeLists.txt`!!!)
then define `CMAKE_BUILD_TYPE` again as the opposite value. This will generate both required libraries for `Release` and `Debug`.

## Windows Build Instructions

### Requirements

I recommend using Visual Studio 2022 and its CMake integration, but through a Visual Studio Developer Command Prompt; which comes with VS2022.

### The Addon

This is pretty similar to building godot-cpp.

Run CMake in the root repository directory `cmake . -B build -G Ninja -DCMAKE_BUILD_TYPE=<INSERT EITHER Release OR Debug HERE>`,
then `cd build && ninja`.

You can run it again for the opposite configuration if you want both debug and release.

After this is done you will have a `.dll` file(s) in the `bin` directory of the addon folder.

## Linux Build Instructions

### Requirements

You will need `cmake`, either the `gcc` toolchain or the `clang`/`llvm` toolchain (this is actually relatively untested as of the latest buildsystem changes, so it may or may not work with Clang anymore).
Also recommended is `ninja-build` for the build system.

### The Addon

It's pretty much the same as the Windows instructions:

Run CMake in the root repository directory, `cmake . -B build -G Ninja -DCMAKE_BUILD_TYPE=<INSERT EITHER Release OR Debug HERE>`,
then `cd build && ninja`.

You can run it again for the opposite configuration if you want both debug and release.

After this is done you will have a `.so` file(s) in the `bin` directory of the addon folder.

## After Build

Now you're pretty much done, just copy the addon directory to your Godot project, reload it if you have it open, enable the importer plugin and boom.
You now can play your mod-tracker formats as a regular audio stream (and even manipulate the playback of them quite a lot).

## Problems?

Open an issue, I'll be happy to take a look. I can't guarantee support though, I'm just a solo hobby developer, but I'm more than willing to take feedback or try to help if I can.

### Common Issues

**M1 Mac: Plugin not loading or crashing**
- Try running the M1 compatibility fix script (see M1/Apple Silicon Compatibility section above)
- Make sure you're using the universal binaries from the latest release

**Build issues on macOS**
- Ensure you have Xcode command line tools installed: `xcode-select --install`
- Make sure CMake is properly detecting your architecture
- Check that all submodules are properly initialized: `git submodule update --init --recursive`
