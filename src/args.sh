function parse-args() {
    local action=$1
    local type=$2
    local addon_name=$3
    local world_name=$4

    if [ -z "$action" ]; then
        echo "ERROR: Missing action"
        show_help; exit 1
    fi

    if [ -z "$type" ]; then
        echo "ERROR: Missing type"
        show_help; exit 1
    fi

    if [ -z "$world_name" ]; then
        echo "ERROR: Missing world_name"
        show_help; exit 1
    fi

    if [ -z "$addon_name" ]; then
        echo "ERROR: Missing addon_name"
        show_help; exit 1
    fi

    # Validate action
    if [[ "$action" != "enable" && "$action" != "disable" ]]; then
        echo "ERROR: Invalid action '$action'. Use 'enable' or 'disable'."
        show_help; exit 1
    fi

    # Validate type
    if [[ "$type" != "behavior" && "$type" != "resource" ]]; then
        echo "ERROR: Invalid type '$type'. Use 'behavior' or 'resource'."
        show_help; exit 1
    fi

    modify_addon "$addon_name" "$world_name" "$type" "$action"
}
