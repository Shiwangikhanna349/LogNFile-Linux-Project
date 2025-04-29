#!/bin/bash

# Ensure necessary directories exist
mkdir -p user_logs
mkdir -p file_reports

# Function to track user logins
track_logins() {
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  FILE="user_logs/logins_$TIMESTAMP.txt"
  
  echo "Current Logged-in Users:" > "$FILE"
  who >> "$FILE"
  echo -e "\nLogin History:" >> "$FILE"
  last -a | head -n 20 >> "$FILE"

  echo "[INFO] Login data collected at $TIMESTAMP" >> lognfile.log
  whiptail --msgbox "Login data saved to $FILE" 10 60
}

# Function to organize files
organize_files() {
  DIR=$(whiptail --inputbox "Enter directory path to organize:" 10 60 3>&1 1>&2 2>&3)
  if [ ! -d "$DIR" ]; then
    whiptail --msgbox "Directory does not exist!" 10 40
    return
  fi

  cd "$DIR"
  mkdir -p Images Documents Scripts Others

  for FILE in *; do
    if [ -f "$FILE" ]; then
      case "$FILE" in
        *.jpg|*.jpeg|*.png) mv "$FILE" Images/ ;;
        *.pdf|*.docx|*.txt) mv "$FILE" Documents/ ;;
        *.sh|*.py|*.js) mv "$FILE" Scripts/ ;;
        *) mv "$FILE" Others/ ;;
      esac
    fi
  done

  cd -
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  echo "[INFO] Files organized in $DIR at $TIMESTAMP" >> lognfile.log
  whiptail --msgbox "Files in $DIR organized successfully!" 10 50
}

# Function to view action logs
view_logs() {
  if [ -f lognfile.log ]; then
    whiptail --textbox lognfile.log 20 70
  else
    whiptail --msgbox "No logs found yet." 10 40
  fi
}

# Main menu
while true; do
  CHOICE=$(whiptail --title "LogNFile - Admin Toolkit" --menu "Choose an option" 15 60 6 \
  "1" "Track User Logins" \
  "2" "Organize Files in a Directory" \
  "3" "View Action Logs" \
  "4" "Exit" 3>&1 1>&2 2>&3)

  case $CHOICE in
    1) track_logins ;;
    2) organize_files ;;
    3) view_logs ;;
    4) exit 0 ;;
  esac
done
