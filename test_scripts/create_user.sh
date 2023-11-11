#!/bin/bash

# Usage: ./create_user.sh username
# Make sure to run this script as root or with sudo privileges

# Variables
USERNAME=$1
MAX_DAYS=90
MIN_DAYS=10
WARN_DAYS=7

# Check if a username is provided
if [ -z "$USERNAME" ]; then
    echo "Usage: $0 username"
    exit 1
fi

# Create a new user and ask to set a password
adduser $USERNAME

# Set password policies
chage -M $MAX_DAYS -m $MIN_DAYS -W $WARN_DAYS $USERNAME

# Force password change on first login
chage -d 0 $USERNAME

echo "$USERNAME has been created with enforced password policies."
