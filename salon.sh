#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -A -F"," -c"
echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"
MAIN_MENU(){
  echo -e "\n$1"
  echo "$($PSQL "SELECT service_id,name FROM services")" | while IFS="," read -r SERVICE_ID SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]
  then
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    # check database for phone number
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      SERVICE_NAME=$($PSQL "SELECT name FROM services where service_id = $SERVICE_ID_SELECTED")
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")     
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    else
      SERVICE_NAME=$($PSQL "SELECT name FROM services where service_id = $SERVICE_ID_SELECTED") 
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
      read SERVICE_TIME
      INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  else
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
  
}
MAIN_MENU

