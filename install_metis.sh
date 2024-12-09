#!/bin/sh

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <INTEGER_SIZE> <INSTALL_PREFIX>"
  exit 1
fi

# Parse input arguments
INTEGER_SIZE=$1
INSTALL_PREFIX=$2

# Validate INT_SIZE (must be an integer)
if ! [[ "$INTEGER_SIZE" =~ ^[0-9]+$ ]]; then
  echo "Error: INTEGER_SIZE must be an integer (32 or 64)."
  exit 1
fi

# Check for right integer sizes
if [ "$INTEGER_SIZE" -ne 32 ] && [ "$INTEGER_SIZE" -ne 64 ]; then
    echo "Invalid INT_SIZE: $INTEGER_SIZE. Defaulting to 32."
    INTEGER_SIZE=32
fi

# Set environment variables
export INTEGER_SIZE
export INSTALL_PREFIX

## Install parmetis
tar -zxf parmetis-4.0.3.tar.gz
cd parmetis-4.0.3

# Fix interger and float sizes
if [ $INTEGER_SIZE = 32 ]; then
  cp ../extra/metis.Int32.h metis/include/metis.h
fi

if [ $INTEGER_SIZE = 64 ]; then
  cp ../extra/metis.Int64.h metis/include/metis.h
fi

# Configure and install libparmetis and parmetis.h
make config cc=$CC cxx=$CXX shared=1 prefix=$INSTALL_PREFIX
make -j4 install

# Configure and install libmetis and metis.h
cd metis
make config  cc=$CC cxx=$CXX shared=1 prefix=$INSTALL_PREFIX
make -j4 install && cd ../.. && rm -rf parmetis-4.0.3

