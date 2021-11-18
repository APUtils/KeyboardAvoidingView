#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""
echo ""

echo -e "Checking Carthage integrity..."
pbxproj_path='KeyboardAvoidingView.xcodeproj/project.pbxproj'
swift_files=$(find 'KeyboardAvoidingView/Classes' -type f -name "*.swift" | grep -o "[0-9a-zA-Z+ ]*.swift" | sort -fu)
swift_files_count=$(echo "${swift_files}" | wc -l | tr -d ' ')

build_section_id=$(sed -n -e '/\/\* KeyboardAvoidingView \*\/ = {/,/};/p' "${pbxproj_path}" | sed -n '/PBXNativeTarget/,/Sources/p' | tail -1 | tr -d "\t" | cut -d ' ' -f 1)
swift_files_in_project=$(sed -n "/${build_section_id}.* = {/,/};/p" "${pbxproj_path}" | grep -o "[A-Z].[0-9a-zA-Z+ ]*\.swift" | sort -fu)
swift_files_in_project_count=$(echo "${swift_files_in_project}" | wc -l | tr -d ' ')
if [ "${swift_files_count}" -ne "${swift_files_in_project_count}" ]; then
    echo  >&2 "error: Carthage project missing dependencies."
    echo -e "\nFinder files:\n${swift_files}"
    echo -e "\nProject files:\n${swift_files_in_project}"
    echo -e "\nMissing dependencies:"
    comm -23 <(echo "${swift_files}") <(echo "${swift_files_in_project}")
    echo " "
	exit 1
fi
echo ""

echo -e "Building Swift Package..."
swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.4-simulator"
echo ""

echo "Building Pods project..."
set -o pipefail && xcodebuild -workspace "Example/KeyboardAvoidingView.xcworkspace" -scheme "KeyboardAvoidingView-Example" -configuration "Release"  -sdk iphonesimulator clean build | xcpretty
echo ""

echo -e "Building Carthage project..."
. "./Scripts/Carthage/utils.sh"
applyXcode12Workaround
set -o pipefail && xcodebuild -project "KeyboardAvoidingView.xcodeproj" -sdk iphonesimulator -target "KeyboardAvoidingView" | xcpretty
echo ""

echo -e "Building with Carthage..."
carthage build --use-xcframeworks --no-skip-current --cache-builds
echo ""

echo -e "Performing tests..."
simulator_id="$(xcrun simctl list devices available iPhone | grep " SE " | tail -1 | sed -e "s/.*(\([0-9A-Z-]*\)).*/\1/")"
if [ -n "${simulator_id}" ]; then
    echo "Using iPhone SE simulator with ID: '${simulator_id}'"

else
    simulator_id="$(xcrun simctl list devices available iPhone | grep "^    " | tail -1 | sed -e "s/.*(\([0-9A-Z-]*\)).*/\1/")"
    if [ -n "${simulator_id}" ]; then
        echo "Using iPhone simulator with ID: '${simulator_id}'"
        
    else
        echo  >&2 "error: Please install iPhone simulator."
        echo " "
        exit 1
    fi
fi

set -o pipefail && xcodebuild -workspace "Example/KeyboardAvoidingView.xcworkspace" -sdk iphonesimulator -scheme "KeyboardAvoidingView-Example" -destination "platform=iOS Simulator,id=${simulator_id}" test | xcpretty

echo ""
echo "SUCCESS!"
echo ""
echo ""
