#!/bin/bash

# if ADDONS_PATH is not set, use default
if [ -z "$ADDONS_PATH" ]; then
    ADDONS_PATH="/addons"
fi

# if DATA_PATH is not set, use default
if [ -z "$DATA_PATH" ]; then
    DATA_PATH="/data"
fi

function show_config() {
    echo "ADDONS_PATH: $1"
    echo "DATA_PATH: $2"
    echo "WORLD_NAME: $3"
    echo "ADDON_NAME: $4"
    echo "ADDON_TYPE: $4"
    echo "MANIFEST_PATH: $6"
    echo "WORLD_JSON: $7"
    echo "ADDON_UUID: $8"
    echo "ADDON_VERSION: $9"
}

function enable_addon() {
    local ADDON_NAME=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3

    # link addon to data path if it does not exist
    if [ ! -d "$ADDONS_PATH/${ADDON_TYPE}_packs/$ADDON_NAME" ]; then
        ln -s "$ADDONS_PATH/${ADDON_TYPE}_packs/$ADDON_NAME" "$DATA_PATH/${ADDON_TYPE}_packs/$ADDON_NAME"
    fi

    # add addon to world
    local MANIFEST_PATH="$ADDONS_PATH/${ADDON_TYPE}_packs/$ADDON_NAME/manifest.json"
    local WORLD_JSON="$DATA_PATH/worlds/$WORLD_NAME/world_${ADDON_TYPE}_packs.json"    
    local ADDON_UUID=$(jq -r '.header.uuid' "$MANIFEST_PATH")
    local ADDON_VERSION=$(jq -r '.header.version' "$MANIFEST_PATH")

    show_config "$ADDONS_PATH" "$DATA_PATH" "$WORLD_NAME" "$ADDON_NAME" "$ADDON_TYPE" "$MANIFEST_PATH" "$WORLD_JSON" "$ADDON_UUID" "$ADDON_VERSION"

    # exit if ADDON_UUID is not in manifest
    if [ -z "$ADDON_UUID" ]; then
        echo "ERROR: $MANIFEST_PATH is missing uuid"
        exit 1
    fi

    # create $WORLD_JSON if it doesn't exist or if it is empty
    if [ ! -f "$WORLD_JSON" ] || [ ! -s "$WORLD_JSON" ]; then
        echo "[]" > "$WORLD_JSON"
    fi

    # exit if ADDON_UUID is already in $WORLD_JSON
    if jq --arg addon_uuid "$ADDON_UUID" 'any(.[]; .pack_id == $addon_uuid)' "$WORLD_JSON" > /dev/null; then
        echo "ERROR: $ADDON_UUID is already in $WORLD_JSON"
        exit 1
    fi

    # add ADDON_UUID to $WORLD_JSON
    jq --arg addon_uuid "$ADDON_UUID" --argjson addon_version "$ADDON_VERSION" \
        '. + [{"pack_id": $addon_uuid, "version": $addon_version}]' "$WORLD_JSON" > .tmp
    mv .tmp "$WORLD_JSON"

    echo "OK"
}

function disable_addon() {
    local ADDON_NAME=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3

    local MANIFEST_PATH="$ADDONS_PATH/${ADDON_TYPE}_packs/$ADDON_NAME/manifest.json"
    local WORLD_JSON="$DATA_PATH/worlds/$WORLD_NAME/world_${ADDON_TYPE}_packs.json"    
    local ADDON_UUID=$(jq -r '.header.uuid' "$MANIFEST_PATH")
    local ADDON_VERSION=$(jq -r '.header.version' "$MANIFEST_PATH")

    show_config "$ADDONS_PATH" "$DATA_PATH" "$WORLD_NAME" "$ADDON_NAME" "$ADDON_TYPE" "$MANIFEST_PATH" "$WORLD_JSON" "$ADDON_UUID" "$ADDON_VERSION"

    # exit if ADDON_UUID is not in manifest
    if [ -z "$ADDON_UUID" ]; then
        echo "ERROR: $MANIFEST_PATH is missing uuid"
        exit 1
    fi

    # exit if ADDON_UUID is not in $WORLD_JSON
    if ! jq --arg addon_uuid "$ADDON_UUID" 'any(.[]; .pack_id == $addon_uuid)' "$WORLD_JSON" > /dev/null; then
        echo "ERROR: $ADDON_UUID is not in $WORLD_JSON"
        exit 1
    fi

    # remove ADDON_UUID from $WORLD_JSON
    jq ". | map(select(.pack_id != \"$ADDON_UUID\"))" "$WORLD_JSON" > .tmp
    mv .tmp "$WORLD_JSON"

    echo "OK"
}

function parse-args() {
    local action=$1
    local type=$2
    local addon_name=$3
    local world_name=$4

    if [ -z "$action" ]; then
        echo "ERROR: Missing action"
        show_help
    fi

    if [ -z "$type" ]; then
        echo "ERROR: Missing type"
        show_help
    fi

    if [ -z "$world_name" ]; then
        echo "ERROR: Missing world_name"
        show_help
    fi

    if [ -z "$addon_name" ]; then
        echo "ERROR: Missing addon_name"
        show_help
    fi

    case $action in
        enable)
            case $type in
                behavior)
                    enable_behavior "$addon_name" "$world_name"
                    ;;
                resource)
                    enable_resource "$addon_name" "$world_name"
                    ;;
                *)
                    echo "Invalid type: $type"
                    show_help
                    ;;
            esac
            ;;
        disable)
            case $type in
                behavior)
                    disable_behavior "$addon_name" "$world_name"
                    ;;
                resource)
                    disable_resource "$addon_name" "$world_name"
                    ;;
                *)
                    echo "Invalid type: $type"
                    show_help
                    ;;
            esac
            ;;
        *)
            echo "Invalid action: $action"
            show_help
            ;;
    esac
}

function enable_behavior() {
    enable_addon "$1" "$2" "behavior"
}

function enable_resource() {
    enable_addon "$1" "$2" "resource"
}

function disable_behavior() {
    disable_addon "$1" "$2" "behavior"
}

function disable_resource() {
    disable_addon "$1" "$2" "resource"
}

function show_help() {
    echo "Minecraft Addon Manager 1.0"
    echo
    echo "Usage:"
    echo "\$ $(basename $0) <enable|disable> <behavior|resource> <world_name> <addon_name>"
    echo
    echo "Example: enable an addon called 'Some Addon 1.2' for a world called 'My Cool World'"
    echo "1. Unzip the addon, then split into resource and/or behavior packs."
    echo "2. Move the behavior pack to ADDONS_PATH/behavior_packs/some-addon-1.2"
    echo "3. Move the resource pack to ADDONS_PATH/resource_packs/some-addon-1.2"
    echo "4. Finally enable the addon for a world called 'My Cool World'"
    echo "\$ $(basename $0) enable resource 'some-addon-1.2' 'My Cool World'"
    echo "\$ $(basename $0) enable behavior 'some-addon-1.2' 'My Cool World'"
    echo
    echo "DATA_PATH:        $DATA_PATH"
    echo "ADDONS_PATH:      $ADDONS_PATH"
    echo
    echo "Worlds path:      $DATA_PATH/worlds"
    echo "Behavior packs:   $ADDONS_PATH/behavior_packs"
    echo "Resource packs:   $ADDONS_PATH/resource_packs"

    exit 1
}

if [ $# -eq 0 ]; then
    show_help
fi

parse-args "$@"
