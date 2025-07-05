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
