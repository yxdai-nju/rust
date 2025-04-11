#!/bin/sh
set -e

# Record the path where this script is run (must be ran under '[project root]/src/bootstrap-buck2')
BOOTSTRAP_BUCK2_PATH=$(pwd)

# Function to create an absolute path symlink
create_absolute_symlink() {
    local target_dir="$1"
    local source_dir="$2"
    
    if [ -e "$target_dir" ]; then
        if [ -L "$target_dir" ]; then
            rm "$target_dir"
        else
            echo "Error: $target_dir exists but is not a symlink"
            exit 1
        fi
    fi
    
    ln -s "$(realpath "$source_dir")" "$target_dir"
    echo "Created symlink: $target_dir -> $(realpath "$source_dir")"
}

# Create symlinks to standard library and compiler sources
create_absolute_symlink "$BOOTSTRAP_BUCK2_PATH/library/src" "$BOOTSTRAP_BUCK2_PATH/../../library"
create_absolute_symlink "$BOOTSTRAP_BUCK2_PATH/compiler/src" "$BOOTSTRAP_BUCK2_PATH/../../compiler"

# Generate BUCK files for third-party dependencies
echo "Generating BUCK file for internal tools..."
reindeer --third-party-dir $BOOTSTRAP_BUCK2_PATH/bootstrap/tools/third-party buckify
echo "Completed"

echo "Generating BUCK file for library..."
reindeer --third-party-dir $BOOTSTRAP_BUCK2_PATH/library buckify
echo "Completed"

# TODO(yxdai-nju): Support building compiler
# echo "Generating BUCK file for compiler..."
# reindeer --third-party-dir $BOOTSTRAP_BUCK2_PATH/compiler buckify
# echo "Completed"
