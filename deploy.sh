#!/bin/bash

set -eux
WRKDIR=$(echo $PWD)
cd lambda-functions
for fldr in * ; do
    if [ -d "$fldr" ]; then
        echo $(pwd)
        cd $fldr
        mkdir "package" -p
        if test -f "requirements.txt"; then
          pip install --target ./package -r requirements.txt
        fi
        rm ../$fldr.zip
        zip -r9 ../$fldr.zip . > /dev/null
        cd $WRKDIR/lambda-functions;
    fi

done
