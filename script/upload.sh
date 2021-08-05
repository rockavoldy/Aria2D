FILE_SIZE=948
FILE_PATH=./app.plist

curl -i -X POST http://drive.ourfor.top/os/iOS/app_ipa.plist \
    -H "Content-Range: bytes 0-947/$FILE_SIZE" \
    -H "Content-Length: $FILE_SIZE" \
    --data-binary "@$FILE_PATH"