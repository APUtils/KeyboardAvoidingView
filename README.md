# KeyboardAvoidingView

[![CI Status](http://img.shields.io/travis/anton-plebanovich/KeyboardAvoidingView.svg?style=flat)](https://travis-ci.org/anton-plebanovich/KeyboardAvoidingView)
[![Version](https://img.shields.io/cocoapods/v/KeyboardAvoidingView.svg?style=flat)](http://cocoapods.org/pods/KeyboardAvoidingView)
[![License](https://img.shields.io/cocoapods/l/KeyboardAvoidingView.svg?style=flat)](http://cocoapods.org/pods/KeyboardAvoidingView)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardAvoidingView.svg?style=flat)](http://cocoapods.org/pods/KeyboardAvoidingView)

Simple solution for keyboard avoiding. View that manages it's bottom constraint constant or frame height to avoid keyboard.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## GIF animation

<img src="Example/KeyboardAvoidingView/Gifs/KeyboardAvoidingClip.gif"/>

## Installation

#### CocoaPods

KeyboardAvoidingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KeyboardAvoidingView"
```

## Usage

Common usage: set `KeyboardAvoidingView` class to any view in storyboard (usually it's base container) that you want to adjust it's bottom constraint or frame height to avoid keyboard.

<img src="Example/KeyboardAvoidingView/Images/KeyboardAvoidingClassSelect.png"/>

See example project for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

KeyboardAvoidingView is available under the MIT license. See the LICENSE file for more info.
