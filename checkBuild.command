#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""

set -o pipefail && xcodebuild -workspace "Example/KeyboardAvoidingView.xcworkspace" -scheme "KeyboardAvoidingView-Example" -configuration "Release"  -sdk iphonesimulator12.2 | xcpretty

echo

xcodebuild -project "KeyboardAvoidingView.xcodeproj" -alltargets  -sdk iphonesimulator12.2 | xcpretty

echo ""
echo "SUCCESS!"
echo ""
