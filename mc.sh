#!/bin/bash

function get_manifest_path() {
    local ADDONS_PATH=$1
    local ADDON_NAME=$2
    local ADDON_TYPE=$3
    local ADDON_PATH=$(get_global_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")
    echo "$ADDON_PATH/manifest.json"
}

function get_addon_uuid() {
    local MANIFEST_PATH=$1
    echo $(jq -r '.header.uuid' "$MANIFEST_PATH")
}

function get_addon_version() {
    local MANIFEST_PATH=$1
    echo $(jq -r '.header.version' "$MANIFEST_PATH")
}

function get_global_addon_path() {
    local ADDONS_PATH=$1
    local ADDON_NAME=$2
    local ADDON_TYPE=$3
    echo "$ADDONS_PATH/${ADDON_TYPE}_packs/$ADDON_NAME"
}

function get_server_addon_path() {
    local ADDONS_PATH=$1
    local ADDON_NAME=$2
    local ADDON_TYPE=$3
    echo "$DATA_PATH/${ADDON_TYPE}_packs/$ADDON_NAME"
}

function exit_if_addon_uuid_not_in_manifest() {
    local MANIFEST_PATH=$1

    # exit if ADDON_UUID is not in manifest
    if [ -z $(get_addon_uuid "$MANIFEST_PATH") ]; then
        echo "ERROR: $MANIFEST_PATH is missing uuid"
        exit 1
    fi
}

function link_addon_path() {
    local ADDON_NAME=$1
    local ADDON_TYPE=$2

    local ADDON_PATH=$(get_global_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")
    local SERVER_PATH=$(get_server_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")

    # link addon to data path if it does not exist
    if [ ! -d "$ADDON_PATH" ]; then
        ln -s "$ADDON_PATH" "$SERVER_PATH"
    fi
}
function create_world_json() {
    if [ ! -f "$WORLD_JSON" ] || [ ! -s "$WORLD_JSON" ]; then
        echo "[]" > "$WORLD_JSON"
    fi
}

function exit_if_addon_uuid_in_world_json() {
    if jq --arg addon_uuid "$ADDON_UUID" 'any(.[]; .pack_id == $addon_uuid)' "$WORLD_JSON" > /dev/null; then
        echo "ERROR: $ADDON_UUID is already in $WORLD_JSON"
        exit 1
    fi
}

function exit_if_addon_uuid_not_in_world_json() {
    if ! jq --arg addon_uuid "$ADDON_UUID" 'any(.[]; .pack_id == $addon_uuid)' "$WORLD_JSON" > /dev/null; then
        echo "ERROR: $ADDON_UUID is not in $WORLD_JSON"
        exit 1
    fi
}

function get_world_json() {
    local DATA_PATH=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3
    echo "$DATA_PATH/worlds/$WORLD_NAME/world_${ADDON_TYPE}_packs.json"
}

function add_addon_to_world_json() {
    jq --arg addon_uuid "$ADDON_UUID" --argjson addon_version "$ADDON_VERSION" \
        '. + [{"pack_id": $addon_uuid, "version": $addon_version}]' "$WORLD_JSON" > .tmp
    mv .tmp "$WORLD_JSON"
}

function remove_addon_from_world_json() {
    jq ". | map(select(.pack_id != \"$ADDON_UUID\"))" "$WORLD_JSON" > .tmp
    mv .tmp "$WORLD_JSON"
}
function enable_addon() {
    local ADDON_NAME=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3

    local WORLD_JSON=$(get_world_json "$DATA_PATH" "$WORLD_NAME" "$ADDON_TYPE")
    local MANIFEST_PATH=$(get_manifest_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")
    local ADDON_UUID=$(get_addon_uuid "$MANIFEST_PATH")
    local ADDON_VERSION=$(get_addon_version "$MANIFEST_PATH")

    show_config "$ADDONS_PATH" "$DATA_PATH" "$WORLD_NAME" "$ADDON_NAME" "$ADDON_TYPE" \
        "$MANIFEST_PATH" "$WORLD_JSON" "$ADDON_UUID" "$ADDON_VERSION"

    exit_if_addon_uuid_not_in_manifest "$MANIFEST_PATH"
    link_addon_path "$ADDON_NAME" "$ADDON_TYPE"
    create_world_json "$WORLD_JSON"
    exit_if_addon_uuid_in_world_json "$WORLD_JSON"
    add_addon_to_world_json "$WORLD_JSON" "$ADDON_UUID" "$ADDON_VERSION"

    echo "Addon $ADDON_NAME of type $ADDON_TYPE enabled for world $WORLD_NAME."
}

function enable_behavior() {
    enable_addon "$1" "$2" "behavior"
}

function enable_resource() {
    enable_addon "$1" "$2" "resource"
}

function disable_addon() {
    local ADDON_NAME=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3

    local MANIFEST_PATH=$(get_manifest_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")
    local WORLD_JSON=$(get_world_json "$DATA_PATH" "$WORLD_NAME" "$ADDON_TYPE")
    local ADDON_UUID=$(get_addon_uuid "$MANIFEST_PATH")

    show_config "$ADDONS_PATH" "$DATA_PATH" "$WORLD_NAME" "$ADDON_NAME" "$ADDON_TYPE" \
        "$MANIFEST_PATH" "$WORLD_JSON" "$ADDON_UUID"

    exit_if_addon_uuid_not_in_manifest "$MANIFEST_PATH"
    exit_if_addon_uuid_not_in_world_json "$WORLD_JSON"
    remove_addon_from_world_json "$WORLD_JSON" "$ADDON_UUID"

    echo "Addon $ADDON_NAME of type $ADDON_TYPE disabled for world $WORLD_NAME."
}

function disable_behavior() {
    disable_addon "$1" "$2" "behavior"
}

function disable_resource() {
    disable_addon "$1" "$2" "resource"
}
function show_help() {
    echo "Minecraft Bedrock Addons Manager 1.0"
    echo
    echo "Usage:"
    echo "\$ $(basename $0) <enable|disable> <behavior|resource> <addon_name> <world_name>"
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
if [ -z "$ADDONS_PATH" ]; then
    ADDONS_PATH="/addons"
fi

if [ -z "$DATA_PATH" ]; then
    DATA_PATH="/data"
fi

if [ $# -eq 0 ]; then
    show_help
fi

parse-args "$@"
