#!/bin/bash

# Script to check if NGINX is running; restarts if not.

SERVICE="nginx"

if systemctl is-active --quiet $SERVICE; then
    echo "$(date): $SERVICE is running." >> /var/log/nginx_monitor.log
else
    echo "$(date): $SERVICE is NOT running. Restarting..." >> /var/log/nginx_monitor.log
    systemctl restart $SERVICE
    if systemctl is-active --quiet $SERVICE; then
        echo "$(date): $SERVICE successfully restarted." >> /var/log/nginx_monitor.log
    else
        echo "$(date): Failed to restart $SERVICE." >> /var/log/nginx_monitor.log
    fi
fi
