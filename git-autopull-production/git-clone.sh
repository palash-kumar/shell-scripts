#!/bin/expect -f

set timeout -1

set username [lindex $argv 0];
set pass [lindex $argv 1];

spawn git clone "https://mg.maestro.com.bd:58480/Palash/maximerp-production.git"
expect "sername" {send -- "$username\n"}
expect "assword" {send -- "$pass\r"; exp_continue}

EXPECTEND
