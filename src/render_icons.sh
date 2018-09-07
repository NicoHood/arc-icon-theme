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


# Takes in an svg-file and an object-id and formats it
# to an inkscape export shell command that inkscape can
# then execute.
formatInkscapeCmd() {

    local CONTEXT=$1
    local OBJECT_ID=$2
    local SIZE=$(sed -r 's/.*\_([0-9]+).*$/\1/' <<< $OBJECT_ID)

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
}

# Generates inkscape export commands for the given
# svg-file that can be piped to inkscape.
genInkscapeCmds() {

    local CONTEXT=$1

    for SIZE in ${SIZES[@]}
    do
        for OBJECT_ID in `cat <($INKSCAPE -S $CONTEXT.svg | grep -E "_$SIZE" | sed 's/\,.*$//')`
        do
            echo $OBJECT_ID >> .$CONTEXT.cache.tmp
            formatInkscapeCmd $CONTEXT $OBJECT_ID
        done
    done
    mv .$CONTEXT.cache.tmp .$CONTEXT.cache
}

# Generates inkscape export commands that matches
# the provided regex pattern.
genInkscapeCmdsFiltered() {
    
    local CONTEXT=$1
    local REGEX=$2
    
    while read -r OBJECT_ID
    do
        echo "Match: $OBJECT_ID" >&2
        formatInkscapeCmd $CONTEXT $OBJECT_ID
    done < <(grep -E $REGEX .$CONTEXT.cache)
}

if [[ ! -z $1 ]]
then
    echo "Rendering objects with IDs matching regex"
    for CONTEXT in ${TYPES[@]}
    do
        if [[ -f .$CONTEXT.cache ]] || { [[ ! -f .$CONTEXT.cache ]] && ($INKSCAPE -S $CONTEXT.svg | grep -E "_[0-9]+" | sed 's/\,.*$//' > .$CONTEXT.cache.tmp); }
        then
            mv .$CONTEXT.cache.tmp .$CONTEXT.cache 2> /dev/null
            genInkscapeCmdsFiltered $CONTEXT $1 | java SplitJob $INKSCAPE --shell
        else
            echo "Failed creating creating object-ID cache for $CONTEXT.svg"
        fi
    done
else
    for CONTEXT in ${TYPES[@]}
    do
        # Only render out the icons if the svg-file has been modified
        # since we finished rendering it out last.
        if [[ $CONTEXT.svg -nt .${CONTEXT}_timestamp ]]
        then
            echo "Rendering icons from $CONTEXT.svg"
            genInkscapeCmds $CONTEXT | java SplitJob $INKSCAPE --shell && touch .${CONTEXT}_timestamp
        else
            echo "No changes to $CONTEXT.svg, skipping..."
        fi
    done
fi
    
# Remove all empty directories from the theme folder.
find $THEMEDIR -type d -empty -delete
