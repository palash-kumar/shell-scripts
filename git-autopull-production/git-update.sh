#!/bin/bash

clear;

WORKLOC="/home/maestro"

WORKTREE="$WORKLOC/maXimErp-production"


# Navigating to location
cd "$WORKTREE"

git branch

FLAG=$(git fetch)
echo "FETCH OUTPUT: $FLAG";

# For Remote
git log FETCH_HEAD --decorate=full > "$WORKLOC/FETCH_HEAD"

# For local
git log HEAD --decorate=full > "$WORKLOC/HEAD"

# Read first 6 lines (Only latest commit from local)
LOCAL="$(head -6 $WORKLOC/HEAD)"

#cat /home/maestro/HEAD
# Read first 6 lines (Only latest commit) shihab
REMOTE="$(head -6 $WORKLOC/FETCH_HEAD)"

LOCAL_HASH=($(echo "$LOCAL" | grep commit))

REMOTE_HASH=($(echo "$REMOTE" | grep commit))


echo -e '\nLOCAL:'
echo "$LOCAL"
echo -e '\nREMOTE:'
echo -e "$REMOTE\n"

# Local Date and Remote Date
L_DATE=($(echo "$LOCAL" | grep Date))
R_DATE=($(echo "$REMOTE" | grep Date))

# Date Format samples
#   Thu Sep 30 14:55:37 2021 +0600  (Git log date format)
#   Sat, 02 Oct 2021 18:20:59 +0600 (System can convert)

R_DATE="${R_DATE[1]}, ${R_DATE[3]} ${R_DATE[2]} ${R_DATE[5]} ${R_DATE[4]} ${R_DATE[6]}"
L_DATE="${L_DATE[1]}, ${L_DATE[3]} ${L_DATE[2]} ${L_DATE[5]} ${L_DATE[4]} ${L_DATE[6]}"
echo "$R_DATE"

# Converting Date
l_datatime=`date -d "${L_DATE}" '+%Y%m%d %H%M%S'`
r_datatime=`date -d "${R_DATE}" '+%Y%m%d %H%M%S'`
echo "Local: $l_datatime"
echo "Remote: $r_datatime"

ldate_arr=($(echo "$l_datatime"))
rdate_arr=($(echo "$r_datatime"))

ldate_add=`echo "${ldate_arr[0]}${ldate_arr[1]}"`
rdate_add=`echo "${rdate_arr[0]}${rdate_arr[1]}"`

# Log file def
D=$(date +"%Y%B%d")
DT=$(date +"%dth %B, %Y %T" )
[[ ! -d "$WORKTREE/erpLog" ]] && mkdir "$WORKTREE/erpLog"; echo "directory: erpLog created."
[[ ! -d "$WORKTREE/erpLog/git-update-log" ]] && mkdir "$WORKTREE/erpLog"; echo "directory: git-update-log created."
LOG_FILE="$WORKLOC/erpLog/git-update-log/git-log-$D"
echo "LOG_FILE: $LOG_FILE"

# Comparing Local and Remote Dates (should be removed after hash analysis)
if [[ "$ldate_add" -lt "$rdate_add" ]]; then
    echo "REQUIRED UPDATE"
    echo "UPDATING Application."
    
    STATUS=$(git diff --name-only --diff-filter=U)
    git add .
    git commit -m "Conflict merged on $DT"

    PULL_RES=$(git pull --no-edit)
    
    echo "PULL RES: $PULL_RES"

    case $PULL_RES in

      *"Already up-to-date"*)
        echo -ne "ALREADY UP-TO-DATE\n"
        ;;
      *"CONFLICT"*)
        [[  -f "$LOG_FILE" ]] && echo "FILE EXIST!" || touch "$LOG_FILE"; echo "$LOG_FILE FILE CREATED!"
        date +"%Y%B%d"
        echo -e "$PULL_RES\n" | cat - "$LOG_FILE" > "$WORKLOC/temp" && mv "$WORKLOC/temp" "$LOG_FILE"       
        date +"%dth %B, %Y %T"  | cat - "$LOG_FILE" > "$WORKLOC/temp" && mv "$WORKLOC/temp" "$LOG_FILE"
        #echo -ne "CONFLICT is there.\n" >> /home/maestro/git-log
        ;;
      *"file changed"*)
        [[  -f "$LOG_FILE" ]] && echo "FILE EXIST!" || touch "$LOG_FILE"; echo "$LOG_FILE FILE CREATED!"
        echo -e "SUCCESS: $PULL_RES\n" | cat - "$LOG_FILE" > "$WORKLOC/temp" && mv "$WORKLOC/temp" "$LOG_FILE"       
        date +"%dth %B, %Y %T"  | cat - "$LOG_FILE" > "$WORKLOC/temp" && mv "$WORKLOC/temp" "$LOG_FILE"
        ;;
      *"Merge made by"*)
        [[  -f "$LOG_FILE" ]] && echo "FILE EXIST!" || touch "$LOG_FILE"; echo "$LOG_FILE FILE CREATED!"
        echo -e "SUCCESS: $PULL_RES\n" | cat - "$LOG_FILE" > "$WORKLOC/temp" && mv "$WORKLOC/temp" "$LOG_FILE"       
        date +"%dth %B, %Y %T"  | cat - "$LOG_FILE" > "$WORKLOC/temp" && mv "$WORKLOC/temp" "$LOG_FILE"
        ;;
    esac
else
    echo "LOCAL IS UP-TO-DATE"
fi

git --work-tree=${WORKTREE} status --porcelain
echo "Remote: $rdate_add"
echo "Local: $ldate_add"


