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
