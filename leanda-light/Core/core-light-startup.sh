#!/bin/bash

 ./wait-for-it.sh rabbitmq:5672 -t 60
 ./wait-for-it.sh elasticsearch:9200 -t 60
# Start the first process
echo "STARTING  Sds.Osdr.Domain.BackEnd"
./Sds.Osdr.Domain.BackEnd & 
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Sds.Osdr.Domain.BackEnd: $status"
  exit $status
fi
echo "STARTED  Sds.Osdr.Domain.BackEnd: $status"

# Start the second process
echo "STARTING  Sds.Osdr.Domain.FrontEnd"
./Sds.Osdr.Domain.FrontEnd & 
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Sds.Osdr.Domain.FrontEnd: $status"
  exit $status
fi

echo "STARTED Sds.Osdr.Domain.FrontEnd"

# Start Sds.Osdr.Persistence"
echo "STARTING  Sds.Osdr.Persistence"
./Sds.Osdr.Persistence & 
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Sds.Osdr.Persistence: $status"
  exit $status
fi

echo "STARTED Sds.Osdr.Persistence"

# Start Sds.Osdr.Domain.SagaHost
echo "STARTING Sds.Osdr.Domain.SagaHost"
./Sds.Osdr.Domain.SagaHost & 
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Sds.Osdr.Domain.SagaHost: $status"
  exit $status
fi

echo "STARTED Sds.Osdr.Domain.SagaHost"

# Start Sds.Osdr.WebApi
echo "STARTING Sds.Osdr.WebApi"
./Sds.Osdr.WebApi & 
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Sds.Osdr.WebApi: $status"
  exit $status
fi

echo "STARTED Sds.Osdr.WebApi"


# Naive check runs checks once a minute to see if either of the processes exited.
# The container exits with an errorif it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 30 seconds

echo "Leanda Core Light is running... Press Ctrl+C to exit."

while sleep 30; do
  ps aux |grep Sds.Osdr.Domain.BackEnd |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep Sds.Osdr.Domain.FrontEnd |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep Sds.Osdr.Persistence |grep -q -v grep
  PROCESS_3_STATUS=$?
  ps aux |grep Sds.Osdr.Domain.SagaHost |grep -q -v grep
  PROCESS_4_STATUS=$?
  ps aux |grep Sds.Osdr.WebApi |grep -q -v grep
  PROCESS_5_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 -o $PROCESS_4_STATUS -ne 0 -o $PROCESS_5_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
  echo "Leanda Core Light is running... Press Ctrl+C to exit."
done

