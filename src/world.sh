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
