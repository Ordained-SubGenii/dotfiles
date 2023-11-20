#!/bin/bash
killall -r xdg-desktop-portal*
sleep 1
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal-gtk &

