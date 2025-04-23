#!/bin/sh
set -ex

# Record the path where this script is run (must be ran under '[rust]/src/bootstrap-buck2')
BOOTSTRAP_BUCK2_PATH=$(pwd)

rsync --delete --archive $BOOTSTRAP_BUCK2_PATH/../../library/  $BOOTSTRAP_BUCK2_PATH/library/src
rsync --delete --archive $BOOTSTRAP_BUCK2_PATH/../../compiler/ $BOOTSTRAP_BUCK2_PATH/compiler/src

# Generate BUCK files for third-party dependencies
echo "Generating BUCK file for internal tools..."
reindeer --third-party-dir $BOOTSTRAP_BUCK2_PATH/bootstrap/tools/third-party buckify
echo "Completed"

echo "Generating BUCK file for library..."
cd $BOOTSTRAP_BUCK2_PATH/library && reindeer buckify
echo "Completed"

echo "Generating BUCK file for compiler..."
reindeer --third-party-dir $BOOTSTRAP_BUCK2_PATH/compiler buckify
echo "Completed"
