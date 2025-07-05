#!/bin/bash
#
# Ian Dennis Miller
# https://github.com/iandennismiller/bedrock-addons-manager
# revision: 505f4a115add1e8f4fbfd8acdf4937415663ac6f 

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

function addon_exists() {
    local ADDONS_PATH=$1
    local ADDON_NAME=$2
    local ADDON_TYPE=$3

    local ADDON_PATH=$(get_global_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")
    if [ -d "$ADDON_PATH" ]; then
        echo "yes"
    fi
}

function link_addon() {
    local ADDON_NAME=$1
    local ADDON_TYPE=$2

    local ADDON_PATH=$(get_global_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")
    local SERVER_PATH=$(get_server_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")

    # link addon to data path if it does not exist
    if [ ! -d "$SERVER_PATH" ]; then
        ln -s "$ADDON_PATH" "$SERVER_PATH"
        echo "Linked addon $ADDON_NAME of type $ADDON_TYPE to $SERVER_PATH."
    fi
}

function unlink_addon() {
    local ADDON_NAME=$1
    local ADDON_TYPE=$2

    local SERVER_PATH=$(get_server_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")

    # unlink addon from data path if it exists
    if [ -d "$SERVER_PATH" ]; then
        rm "$SERVER_PATH"
        echo "Unlinked addon $ADDON_NAME of type $ADDON_TYPE from $SERVER_PATH."
    fi
}

function modify_addon() {
    local ADDON_NAME=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3
    local ADDON_ACTION=$4

    local WORLD_JSON=$(get_world_json "$DATA_PATH" "$WORLD_NAME" "$ADDON_TYPE")
    local MANIFEST_PATH=$(get_global_addon_path "$ADDONS_PATH" "$ADDON_NAME" "$ADDON_TYPE")/manifest.json
    local ADDON_UUID=$(get_addon_uuid "$MANIFEST_PATH")
    local ADDON_VERSION=$(get_addon_version "$MANIFEST_PATH")

    # show_config "$ADDONS_PATH" "$DATA_PATH" "$WORLD_NAME" "$ADDON_NAME" "$ADDON_TYPE" \
        # "$MANIFEST_PATH" "$WORLD_JSON" "$ADDON_UUID" "$ADDON_VERSION"

    if [ "$ADDON_ACTION" != "enable" ] && [ "$ADDON_ACTION" != "disable" ]; then
        echo "ERROR: Invalid action '$ADDON_ACTION'. Use 'enable' or 'disable'."
        exit 1
    fi

    if [ "$ADDON_ACTION" == "enable" ]; then
        exit_if_addon_uuid_not_in_manifest "$MANIFEST_PATH"
        create_world_json "$WORLD_JSON"
        exit_if_addon_uuid_in_world_json "$WORLD_JSON" "$ADDON_UUID"
        link_addon "$ADDON_NAME" "$ADDON_TYPE"
        add_addon_to_world_json "$WORLD_JSON" "$ADDON_UUID" "$ADDON_VERSION"
        echo "Addon $ADDON_NAME of type $ADDON_TYPE enabled for world $WORLD_NAME."
    else
        exit_if_addon_uuid_not_in_manifest "$MANIFEST_PATH"
        exit_if_addon_uuid_not_in_world_json "$WORLD_JSON" "$ADDON_UUID"
        unlink_addon "$ADDON_NAME" "$ADDON_TYPE"
        remove_addon_from_world_json "$WORLD_JSON" "$ADDON_UUID"
        echo "Addon $ADDON_NAME of type $ADDON_TYPE disabled for world $WORLD_NAME."
    fi
}

function list_available_addons() {
    local ADDONS_PATH=$1
    local ADDON_TYPE=$2

    local ADDON_DIR="$ADDONS_PATH/${ADDON_TYPE}_packs"
    if [ ! -d "$ADDON_DIR" ]; then
        echo "No addons of type $ADDON_TYPE found."
        return
    fi

    echo "Available addons:"
    echo
    for ADDON in "$ADDON_DIR"/*; do
        if [ -d "$ADDON" ]; then
            local ADDON_NAME=$(basename "$ADDON")
            echo "- $ADDON_NAME"
        fi
    done
}

function get_addon_name_from_uuid() {
    local ADDONS_PATH=$1
    local ADDON_UUID=$2
    local ADDON_TYPE=$3

    local ADDON_DIR="$ADDONS_PATH/${ADDON_TYPE}_packs"
    for ADDON in "$ADDON_DIR"/*; do
        if [ -d "$ADDON" ]; then
            local MANIFEST_PATH="$ADDON/manifest.json"
            if [ -f "$MANIFEST_PATH" ]; then
                local UUID=$(get_addon_uuid "$MANIFEST_PATH")
                if [ "$UUID" == "$ADDON_UUID" ]; then
                    echo "$(basename "$ADDON")"
                    return
                fi
            fi
        fi
    done

    echo "Addon with UUID $ADDON_UUID not found."
}
function get_addon_uuid() {
    local MANIFEST_PATH=$1
    echo $(jq -r '.header.uuid' "$MANIFEST_PATH")
}

function get_addon_version() {
    local MANIFEST_PATH=$1
    echo $(jq -r '.header.version' "$MANIFEST_PATH")
}

function exit_if_addon_uuid_not_in_manifest() {
    local MANIFEST_PATH=$1

    # exit if ADDON_UUID is not in manifest
    if [ -z $(get_addon_uuid "$MANIFEST_PATH") ]; then
        echo "ERROR: $MANIFEST_PATH is missing uuid"
        exit 1
    fi
}
function get_world_json() {
    local DATA_PATH=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3
    echo "$DATA_PATH/worlds/$WORLD_NAME/world_${ADDON_TYPE}_packs.json"
}

function create_world_json() {
    WORLD_JSON=$1
    if [ ! -f "$WORLD_JSON" ] || [ ! -s "$WORLD_JSON" ]; then
        echo "[]" > "$WORLD_JSON"
    fi
}

function is_addon_uuid_in_world_json() {
    ADDON_UUID=$1
    WORLD_JSON=$2
    # check if jq == true
    if [[ $(jq "any(.[]; .pack_id == \"$ADDON_UUID\")" "$WORLD_JSON") == "true" ]]; then
        return 0
    fi
    return 1
}

function exit_if_addon_uuid_in_world_json() {
    WORLD_JSON=$1
    ADDON_UUID=$2
    if is_addon_uuid_in_world_json "$ADDON_UUID" "$WORLD_JSON"; then
        echo "ERROR: $ADDON_UUID is already in $WORLD_JSON"
        exit 1
    fi
}

function exit_if_addon_uuid_not_in_world_json() {
    WORLD_JSON=$1
    ADDON_UUID=$2
    if ! is_addon_uuid_in_world_json "$ADDON_UUID" "$WORLD_JSON"; then
        echo "ERROR: $ADDON_UUID is not in $WORLD_JSON"
        exit 1
    fi
}

function add_addon_to_world_json() {
    WORLD_JSON=$1
    ADDON_UUID=$2
    ADDON_VERSION=$3
    jq --arg addon_uuid "$ADDON_UUID" --argjson addon_version "$ADDON_VERSION" \
        '. + [{"pack_id": $addon_uuid, "version": $addon_version}]' "$WORLD_JSON" > .tmp
    mv .tmp "$WORLD_JSON"
}

function remove_addon_from_world_json() {
    WORLD_JSON=$1
    ADDON_UUID=$2
    jq ". | map(select(.pack_id != \"$ADDON_UUID\"))" "$WORLD_JSON" > .tmp
    mv .tmp "$WORLD_JSON"
}

function list_enabled_addons() {
    local DATA_PATH=$1
    local WORLD_NAME=$2
    local ADDON_TYPE=$3

    local WORLD_JSON=$(get_world_json "$DATA_PATH" "$WORLD_NAME" "$ADDON_TYPE")

    echo "Enabled for world $WORLD_NAME:"
    echo
    for uuid in $(jq -r '.[].pack_id' "$WORLD_JSON"); do
        local addon_name=$(get_addon_name_from_uuid "$ADDONS_PATH" "$uuid" "$ADDON_TYPE")
        if [ -n "$addon_name" ]; then
            echo "- $addon_name"
        else
            echo "- Unknown addon (UUID: $uuid)"
        fi
    done
}
function parse-args() {
    local action=$1

    if [ -z "$action" ]; then
        echo "ERROR: Missing action"
        show_help; exit 1
    fi

    # if action is 'list', we don't need addon_name or world_name
    if [ "$action" == "list" ]; then
        local world_name=$2

        if [ -z "$world_name" ]; then
            echo "ERROR: Missing world_name"
            show_help; exit 1
        fi

        list_enabled_addons "$DATA_PATH" "$world_name" behavior
        echo
        exit 0
    fi

    if [ "$action" == "list-all" ]; then
        list_available_addons "$ADDONS_PATH" behavior
        echo
        exit 0
    fi

    # if action is enable or disable, we need addon_name and world_name
    if [ "$action" == "enable" ] || [ "$action" == "disable" ]; then
        local world_name=$2
        local addon_name=$3

        if [ -z "$addon_name" ]; then
            echo "ERROR: Missing addon_name for action '$action'."
            show_help; exit 1
        fi

        if [ -z "$world_name" ]; then
            echo "ERROR: Missing world_name for action '$action'."
            show_help; exit 1
        fi

        modify_addon "$addon_name" "$world_name" behavior "$action"
        modify_addon "$addon_name" "$world_name" resource "$action"
        exit 0
    fi

    show_help
    exit 1
}
function show_config() {
    echo "ADDONS_PATH: $1"
    echo "DATA_PATH: $2"
    echo "WORLD_NAME: $3"
    echo "ADDON_NAME: $4"
    echo "ADDON_TYPE: $5"
    echo "MANIFEST_PATH: $6"
    echo "WORLD_JSON: $7"
    echo "ADDON_UUID: $8"
    echo "ADDON_VERSION: $9"
}

function show_help() {
    echo "Bedrock Addons Manager"
    echo "https://github.com/iandennismiller/bedrock-addons-manager"
    echo
    echo "Usage:"
    echo
    echo "mc.sh ACTION [WORLD_NAME] [ADDON_NAME]"
    echo
    echo "Action is required, and can be one of the following:"
    echo
    echo "  enable WORLD ADDON   Enable an addon for a world"
    echo "  disable WORLD ADDON  Disable an addon for a world"
    echo "  list WORLD           List enabled addons for a world"
    echo "  list-all             List all available addons"
    echo "  help                 Show this help message"
    echo
}

function show_example() {
    echo "Example: enable an addon called 'Some Addon 1.2' for a world called 'My Cool World'"
    echo "1. Unzip the addon, then split into resource and/or behavior packs."
    echo "2. Move the behavior pack to ADDONS_PATH/behavior_packs/some-addon-1.2"
    echo "3. Move the resource pack to ADDONS_PATH/resource_packs/some-addon-1.2"
    echo "4. Finally enable the addon for a world called 'My Cool World'"
    echo "mc.sh enable 'My Cool World' 'some-addon-1.2'"
}
if [ -z "$ADDONS_PATH" ]; then
    ADDONS_PATH="/addons"
fi

if [ -z "$DATA_PATH" ]; then
    DATA_PATH="/data"
fi

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

parse-args "$@"
