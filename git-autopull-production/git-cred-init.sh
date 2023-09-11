#!/bin/bash

set username [lindex $argv 0];
set pass [lindex $argv 1];

git config --global credential.helper store
git config --global user.name "$username"
git config --global user.password "$pass"
git config --global user.email "support@maestro.com.bd"

