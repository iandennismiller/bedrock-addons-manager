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
