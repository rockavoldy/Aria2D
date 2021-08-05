#/bin/bash!
project="Aria2D.xcodeproj"
configuration="Release"
options="options.plist"
output="dist"


function build () {
    local project=$1
    local scheme=$2
    local configuration=$3
    local options=$4
    local archive=$5
    local package=$6
    xcodebuild -project $project -scheme "$scheme" -configuration $configuration clean | xcpretty
    xcodebuild archive -project $project -scheme "$scheme" -configuration $configuration -archivePath $archive | xcpretty
    xcodebuild -exportArchive -exportOptionsPlist $options -archivePath $archive -exportPath $package -allowProvisioningUpdates | xcpretty
}

rm -rf $output

# macOS build
scheme="Aria2D"
archive="$output/Aria2D.xcarchive"
package="$output/macOS-Package"
build $project "$scheme" $configuration $options $archive $package