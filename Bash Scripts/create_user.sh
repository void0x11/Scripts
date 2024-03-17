#!/bin/bash

# Usage: ./create_user.sh username groupname
# Make sure to run this script as root or with sudo privileges

# Variables
USERNAME=$1
GROUPNAME=$2
MAX_DAYS=90
MIN_DAYS=10
WARN_DAYS=7

# Check if a username and groupname are provided
if [ -z "$USERNAME" ] || [ -z "$GROUPNAME" ]; then
    echo "Usage: $0 username groupname"
    exit 1
fi

# Check if the provided group exists
if ! getent group "$GROUPNAME" > /dev/null; then
    echo "The group '$GROUPNAME' does not exist."
    exit 1
fi

# Create a new user and assign the existing group
adduser --ingroup "$GROUPNAME" "$USERNAME"

# Set password policies
chage -M "$MAX_DAYS" -m "$MIN_DAYS" -W "$WARN_DAYS" "$USERNAME"

# Force password change on first login
chage -d 0 "$USERNAME"

echo "$USERNAME has been created with enforced password policies and added to the $GROUPNAME group."
