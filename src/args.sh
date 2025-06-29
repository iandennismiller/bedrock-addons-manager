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
