# PathMorphing

PathMorphing provides tools for animating the transition between two CGPaths.

<img src="https://github.com/AndreiArdelean1/PathMorphing/blob/master/Resources/PlaneToCircle.gif" width="200" height="200">

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [License](#license)

[//]: # (## Features)
[//]: # (
[//]: # (- [x] QQQWERTYUIOPOIUYTREWQ)

## Requirements

- iOS 8.0+ / macOS 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 10.1+
- Swift 4.2+


## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate PathMorphing into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'PathMorphing'
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate PathMorphing into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add PathMorphing as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/AndreiArdelean1/PathMorphing.git
  ```

- Open the new `PathMorphing` folder, and drag the `PathMorphing.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `PathMorphing.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.

- Select `PathMorphing.framework`.

- And that's it!

  > The `PathMorphing.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

## License

PathMorphing is released under the MIT license. [See LICENSE](https://github.com/AndreiArdelean1/PathMorphing/blob/master/LICENSE) for details.
