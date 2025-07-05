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
