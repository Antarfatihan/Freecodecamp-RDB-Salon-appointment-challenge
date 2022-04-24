#! /bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
      echo "Welcome to My Salon, how can I help you?"   
  fi

   
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_MENU $SERVICE_ID_SELECTED;;
    2) APPOINTMENT_MENU $SERVICE_ID_SELECTED;;
    3) APPOINTMENT_MENU $SERVICE_ID_SELECTED;;
    4) APPOINTMENT_MENU $SERVICE_ID_SELECTED;;
    5) APPOINTMENT_MENU $SERVICE_ID_SELECTED;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

APPOINTMENT_MENU(){
  SERVICE_NAME=$($PSQL "select name from services where service_id=$1")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  if [[ $CUSTOMER_PHONE =~ ^[0-9]+$ ]]
  then
      MAIN_MENU "That is not a valid number."
  else 
      NUMBER_AVAILABLE=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")
      if [[ -z $NUMBER_AVAILABLE ]]
      then
          echo "I don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME
          echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
          read SERVICE_TIME
          echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
          INSERT_DATA_CUSTOMERS=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME') ")
          INSERT_DATA_APPOINTMENT=$($PSQL "insert into appointments(service_id,time) values($1,'$SERVICE_TIME') ")
      fi
  fi        
}


MAIN_MENU
