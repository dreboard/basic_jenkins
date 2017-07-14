#!/usr/bin/env bash

echo "=====================Restarting apache and updating composer"

#-------Start/restart apache
if [ apache2 ]; then
    sudo service apache2 restart
fi




