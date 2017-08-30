#!/bin/bash

INKSCAPE="/usr/bin/inkscape"

pushd `dirname $0` > /dev/null
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
popd > /dev/null

cd ${DIR}

TYPES=(actions apps categories devices emblems mimetypes places status)
SIZES=(16 22 24 32 48 64 96 128)

THEMEDIR=../Arc

# Set up all the folders in the theme directory.
mkdir -p $THEMEDIR/{actions,apps,categories,devices,emblems,mimetypes,places,status}/{16,22,24,32,48,64,96,128}{,@2x}

cp -u index.theme $THEMEDIR/index.theme

for CONTEXT in ${TYPES[@]}
do
    for SIZE in ${SIZES[@]}
    do
        cp -ru $CONTEXT/symlinks/* $THEMEDIR/$CONTEXT/$SIZE
        cp -ru $CONTEXT/symlinks/* $THEMEDIR/$CONTEXT/$SIZE@2x
        cp -ru $CONTEXT/symbolic $THEMEDIR/$CONTEXT
    done
done

rm -rf $THEMEDIR/actions/{32,32@2x,48,48@2x,64,64@2x,96,96@2x,128,128@2x} # derp

# TODO
cp -ru animations $THEMEDIR/.
cp -ru panel $THEMEDIR/.


# Generates inkscape export commands for the given
# svg-file that can be piped to inkscape.
genInkscapeCmds() {

    local CONTEXT=$1

    for SIZE in ${SIZES[@]}
    do
        echo "Rendering icons $CONTEXT.svg @$SIZE" >&2
        for OBJECT_ID in `cat <($INKSCAPE -S $CONTEXT.svg | grep -E "_$SIZE" | sed 's/\,.*$//')`
        do
            local ICON_NAME=$(sed "s/\_$SIZE.*$//" <<< $OBJECT_ID)

            echo \
                "--export-id=$OBJECT_ID" \
                "--export-id-only" \
                "--export-png=$THEMEDIR/$CONTEXT/$SIZE/$ICON_NAME.png $CONTEXT.svg"
    
            echo \
                "--export-id=$OBJECT_ID" \
                "--export-dpi=180" \
                "--export-id-only" \
                "--export-png=$THEMEDIR/$CONTEXT/$SIZE@2x/$ICON_NAME.png $CONTEXT.svg"
        done
    done
}

for CONTEXT in ${TYPES[@]}
do
    # Only render out the icons if the svg-file has been modified
    # since we finished rendering it out last.
    if [[ $CONTEXT.svg -nt .${CONTEXT}_timestamp ]]
    then
        genInkscapeCmds $CONTEXT | $INKSCAPE --shell > /dev/null && touch .${CONTEXT}_timestamp &
    else
        echo "No changes to $CONTEXT.svg, skipping..."
    fi
done

wait

# Remove all empty directories from the theme folder.
find $THEMEDIR -type d -empty -delete
