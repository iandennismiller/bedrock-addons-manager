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
