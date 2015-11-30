#!/bin/bash

cd /config

/sbin/setuser nobody curl https://install.meteor.com/ | /sbin/setuser nobody sh

if [ ! -d "/config/plexrequests-meteor" ]; then
  echo "First install detected, cloning repository"
  git clone https://github.com/lokenx/plexrequests-meteor.git
  cd plexrequests-meteor
else
  echo "Updating repository"
  cd plexrequests-meteor
  git reset --hard
  git pull
fi

if [ -z "$BRANCH" ]; then
  BRANCH="master"
fi

echo "Using the $BRANCH branch"
git checkout -f $BRANCH

chown -R nobody:users /config
chmod -R g+rw /config

/sbin/setuser nobody meteor update
/sbin/setuser nobody meteor &
