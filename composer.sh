#!/usr/bin/env bash

if [ php ] ; then
	echo "============================Updating composer..........."
	composer install
else
	echo "============================All good may have to update"
fi

