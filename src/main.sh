if [ -z "$ADDONS_PATH" ]; then
    ADDONS_PATH="/addons"
fi

if [ -z "$DATA_PATH" ]; then
    DATA_PATH="/data"
fi

if [ $# -eq 0 ]; then
    show_help
fi

parse-args "$@"
