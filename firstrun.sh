#!/bin/bash

cd /config

if [ ! -d "/home/.meteor" ]; then
  echo "Fresh container detected; installing Meteor. This may take 10+ minutes!!"
  /sbin/setuser nobody curl https://install.meteor.com/ | /sbin/setuser nobody sh
else
  echo "Restarted container, Meteor already installed"
fi

if [ ! -d "/config/plexrequests-meteor" ]; then
  echo "First install detected, cloning PlexRequests repository"
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

/sbin/setuser nobody /home/.meteor/meteor update
/sbin/setuser nobody /home/.meteor/meteor &
