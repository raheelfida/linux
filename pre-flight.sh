#!/bin/bash

# 1. Print OS information
echo "### OS Information ###"
uname -a
echo
cat /etc/os-release
echo

# 2. Print current private IP
PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "Private IP: $PRIVATE_IP"
echo

# 3. Ask user to enter new hostname and set it
read -rp "Enter new hostname: " NEW_HOSTNAME
echo "$NEW_HOSTNAME" > /etc/hostname
hostnamectl set-hostname "$NEW_HOSTNAME"
echo "Hostname set to $NEW_HOSTNAME"
echo

# 4. Add new hostname to /etc/hosts
if grep -q "$PRIVATE_IP" /etc/hosts; then
    sed -i "s/^$PRIVATE_IP.*/$PRIVATE_IP $NEW_HOSTNAME/" /etc/hosts
else
    echo "$PRIVATE_IP $NEW_HOSTNAME" >> /etc/hosts
fi
echo "Updated /etc/hosts"
echo

# 5. Update and upgrade packages
echo "Updating and upgrading packages..."
apt update && apt upgrade -y
echo "System update complete."
echo

# 6. Ask for new username and create user
read -rp "Enter new username to add: " NEW_USER
RANDOM_PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c8)
useradd -m -s /bin/bash "$NEW_USER"
echo "$NEW_USER:$RANDOM_PASSWORD" | chpasswd
usermod -aG sudo "$NEW_USER"
echo "User $NEW_USER created and added to sudo group."
echo

# 7. Display and save credentials
echo "Username: $NEW_USER"
echo "Password: $RANDOM_PASSWORD"

CREDENTIAL_FILE="$HOME/credentials.txt"

# Ensure the file exists before writing
touch "$CREDENTIAL_FILE"

# Write credentials
{
    echo "Username: $NEW_USER"
    echo "Password: $RANDOM_PASSWORD"
} > "$CREDENTIAL_FILE"

chmod 600 "$CREDENTIAL_FILE"
echo "Credentials saved to $CREDENTIAL_FILE"

echo

# 8. Force password change on first login
chage -d 0 "$NEW_USER"
echo "User $NEW_USER will be required to change password on first login."

echo "All tasks completed successfully."
