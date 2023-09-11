#!/bin/bash
clear

WORKLOC=/home/maestro

WORKTREE="$WORKLOC"

username="support"
pass="bbone29sp"
cd "$WORKTREE"

pwd

echo "Please Enter DB username:"
read db
echo "Password for $db:"
read dbpass

# Installing required packages
os=$(cat /etc/os-release | grep NAME)
sub="CentOS"
#if [[ "$os" == "$sub" ]]; then
  yum install expect
#else
 #   apt-get install expect
#fi

echo "Installing application maXimErp"

# Expect script for login to clone
[[ ! -d "$WORKTREE/maXimErp-production" ]] && $WORKTREE/git-clone.sh $username $pass; echo "Application Download Complete!"

# Renaming application
mv "$WORKTREE/maximerp-production" "$WORKTREE/maXimErp-production"

# configure git credentials
PROJECT="$WORKTREE/maXimErp-production"
cd "$PROJECT"

$WORKTREE/git-cred-init.sh $username $pass

# Creating required Directories
echo "Creating required files..."
[[ ! -d "$WORKTREE/erpLog" ]] && mkdir "$WORKTREE/erpLog"; echo "directory: erpLog created."
[[ ! -d "$WORKTREE/erpLog/git-update-log" ]] && mkdir "$WORKTREE/erpLog/git-update-log"; echo "directory: git-update-log created."
[[ ! -f "$WORKTREE/erpLog/app.log" ]] && touch "$WORKTREE/erpLog/app.log"; echo "directory: erpLog/app.log created."
[[ ! -d "$WORKTREE/erpImages" ]] && mkdir "$WORKTREE/erpImages"; echo "directory: erpImages created."
[[ ! -d "$WORKTREE/erpImages/Inventory" ]] && mkdir "$WORKTREE/erpImages/Inventory"; echo "directory: erpImages/Inventory created."
[[ ! -d "$WORKTREE/erpDoc" ]] && mkdir "$WORKTREE/erpDoc"; echo "directory: erpDoc created."
[[ ! -d "$WORKTREE/erpDoc/Inventory" ]] && mkdir "$WORKTREE/erpDoc/Inventory"; echo "directory: erpDoc/Inventory created."
[[ ! -d "$WORKTREE/appConfig" ]] && mkdir "$WORKTREE/appConfig"; echo "directory: appConfig created."
[[ ! -f "$WORKTREE/appConfig/application-live.properties" ]] && touch "$WORKTREE/appConfig/application-live.properties"; echo "directory: /appConfig/application-live.properties created."
[[ ! -f "$WORKTREE/appConfig/credentials-live.properties" ]] && touch "$WORKTREE/appConfig/credentials-live.properties"; echo "directory: /appConfig/credentials-live.properties created."
[[ ! -f "$WORKTREE/appConfig/credentials-mail-live.properties" ]] && touch "$WORKTREE/appConfig/credentials-mail-live.properties"; echo "directory: /appConfig/credentials-mail-live.properties created."

app="# ThymeLeaf
spring.thymeleaf.cache=false

spring.thymeleaf.check-template-location=true

spring.jpa.hibernate.ddl-auto=none

spring.session.store-type=jdbc

spring.session.jdbc.table-name=SPRING_SESSION

spring.datasource.initialization-mode=always

spring.config.location=file:F:/devConfig/erp_data

spring.jpa.database-platform=org.hibernate.dialect.Oracle10gDialect

spring.datasource.driver-class-name=oracle.jdbc.driver.OracleDriver

spring.jpa.show-sql=false

# logging
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} %-5level %logger{36} - %msg%n

#hikari setup for connection pool
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.maximum-pool-size=10

#server Port
server.port = 8001

#jmx
spring.jmx.default-domain=maximerp
spring.jmx.enabled=false

#File Path
empImagePath=/home/maestro/erpImages
inventoryImagePath=/home/maestro/erpImages/Inventory
inventoryDocPath=/home/maestro/erpDoc/Inventory

#Log Path
logging.file=/home/maestro/erpLog/app.log   

#Thread Pool
thread.pool.size=3

fixed-delay.in.milliseconds=600000
fixed-rate.in.milliseconds=2000
daily-night=0 50 22 * * *
monthly-payroll=0 15 9 24 * *"

echo "$app" > "$WORKTREE/appConfig/application-live.properties"

creds="spring.datasource.url=jdbc:oracle:thin:@localhost:1521:maximdb
spring.datasource.username=$db
spring.datasource.password=$dbpass"

echo "$creds" > "$WORKTREE/appConfig/credentials-live.properties"

mail="# Mail Configuration
spring.mail.host=smtp.gmail.com
spring.mail.properties.mail.smtp.ssl.trust=smtp.gmail.com
#spring.mail.port=465
spring.mail.port=587

spring.mail.properties.mail.transport.protocol=smtp
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.debug=true
spring.mail.properties.mail.smtp.timeout=1000"

echo "Do you want to configure E-mail? (Y/N): "
read mailOption
if [ $mailOption == "Y" ] || [ $mailOption == "y" ];
then
echo "Please provide gmail address: "
read gmail

echo "Please provide gmail pass: "
read gmailPass

mail="$mail \nspring.mail.username=$gmail
spring.mail.password=$gmailPass"
else
mail="$mail \n spring.mail.username=example@abcd.com
spring.mail.password=123456 "
fi
echo -e "$mail" > "$WORKTREE/appConfig/credentials-mail-live.properties"
