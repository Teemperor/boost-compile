#!/bin/bash

rm -rf build

export CC=$1
export CXX=$2

set -e

if [[ "$4" == "On" ]]; then
  echo "Testing CMS boost"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"
cd ..
rm -rf build
mkdir build
cd build

# Will keep travis alive by producing output
bash "$DIR/print_status.sh" "$DIR/../build/pcm" &
BUSY_PID=$!

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM

cmake -Duse_modules=$3 -Dcms=$4 ..
if [[ "$3" == "On" || "$3" == "print" ]]; then
  echo "Building with modules on"
  set +e
  make -k VERBOSE=1
  set -e
  find . -name "boost_*.pcm" | xargs -L1 basename | rev | cut -c 5- | rev > found_pcms
  echo "Found PCMS:"
  cat found_pcms
  if [[ "$4" == "On" ]]; then
    python "$DIR/check_pcms.py" "$DIR/../working_pcms-cms" found_pcms
  else
    python "$DIR/check_pcms.py" "$DIR/../working_pcms" found_pcms
  fi
  python "$DIR/size_check_pcms.py"
else
  echo "Building with modules off"
  make VERBOSE=1
fi

set +e
kill $BUSY_PID
set -e
exit 0
