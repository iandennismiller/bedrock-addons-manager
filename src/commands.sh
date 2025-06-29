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
