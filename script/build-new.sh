#/bin/bash!
project="Aria2D.xcodeproj"
configuration="Release"
options="options.plist"
output="dist"
code_sign_identity="Akhmad Maulana Akbar"

function build () {
    local project=$1
    local scheme=$2
    local configuration=$3
    local options=$4
    local archive=$5
    local package=$6
    local code_sign_id=$7
    
    xcodebuild -project $project -scheme "$scheme" -configuration $configuration archive CODE_SIGN_IDENTITY="$code_sign_id" -archivePath "$archive"
    plutil -convert xml1 - -o "$options" << EOF
      {
        "destination": "export",
        "method": "mac-application"
      }
EOF

    xcodebuild -exportArchive -archivePath "$archive" -exportPath "$package" -exportOptionsPlist "$options"
}

rm -rf $output

# macOS build
scheme="Aria2D"
archive="$output/Aria2D.xcarchive"
package="$output/macOS-Package"
build $project "$scheme" $configuration $options $archive $package $code_sign_id
codesign --force --deep -s "$code_sign_identity" "$package/Aria2D.app"

