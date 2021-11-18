# KeyboardAvoidingView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Version](https://img.shields.io/cocoapods/v/KeyboardAvoidingView.svg?style=flat)](http://cocoapods.org/pods/KeyboardAvoidingView)
[![License](https://img.shields.io/cocoapods/l/KeyboardAvoidingView.svg?style=flat)](http://cocoapods.org/pods/KeyboardAvoidingView)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardAvoidingView.svg?style=flat)](http://cocoapods.org/pods/KeyboardAvoidingView)
[![CI Status](http://img.shields.io/travis/APUtils/KeyboardAvoidingView.svg?style=flat)](https://travis-ci.org/APUtils/KeyboardAvoidingView)

Simple solution for keyboard avoiding. View that manages it's bottom constraint constant or frame height to avoid keyboard.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## GIF animation

<img src="Example/KeyboardAvoidingView/Gifs/KeyboardAvoidingClip.gif"/>

## Installation

#### Carthage

**If you are setting `KeyboardAvoidingView` class in storyboard assure module field is also `KeyboardAvoidingView`**

<img src="Example/KeyboardAvoidingView/Images/customClass.png"/>

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/KeyboardAvoidingView" ~> 5.2
```

Then add both `KeyboardAvoidingView` and `ViewState` frameworks to your project. Remove `APExtensionsViewState` dependency if you previously had it.

#### CocoaPods

KeyboardAvoidingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KeyboardAvoidingView", '~> 5.2'
```

#### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding `KeyboardAvoidingView` as a dependency is as easy as adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/APUtils/KeyboardAvoidingView.git", .upToNextMajor(from: "5.2.0"))
]
```

## Usage

Just set `KeyboardAvoidingView` class to any view in storyboard (usually it's base container) that you want to adjust it's bottom constraint or frame height to avoid keyboard, **assure module field is also `KeyboardAvoidingView`**. 

<img src="Example/KeyboardAvoidingView/Images/customClass.png"/>

It's also possible to create it from code:
```swift
let keyboardAvoidingView = KeyboardAvoidingView(frame: containerView.bounds)
keyboardAvoidingView.translatesAutoresizingMaskIntoConstraints = true
keyboardAvoidingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

containerView.addSubview(keyboardAvoidingView)
```

In most cases it should be only one `KeyboardAvoidingView` for screen. Be sure to not create nested `KeyboardAvoidingView`'s.

See example project for more details.

## Usage together with IQKeyboardManager

`KeyboardAvoidingView` more likely will conflict with `IQKeyboardManager` so you have to disable `IQKeyboardManager` on the screen you are using `KeyboardAvoidingView`. Please reffer to the `IQKeyboardManager` [documentation](http://cocoadocs.org/docsets/IQKeyboardManager/5.0.4/Classes/IQKeyboardManager.html#//api/name/disabledDistanceHandlingClasses). More likely it'll look something like this:
```swift
IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(contentsOf: [MyViewController.self])
```

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

KeyboardAvoidingView is available under the MIT license. See the LICENSE file for more info.
