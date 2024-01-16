#!/bin/zsh
BASEDIR=$(dirname "$0")
source ${BASEDIR}/workout.env

bearer_token=$(curl https://api.dropbox.com/oauth2/token \
    -d grant_type=refresh_token \
    -d refresh_token=${refresh_token} \
    -d client_id=${app_key} \
    -d client_secret=${app_secret}| jq -r '.access_token')

raw_workouts=$(curl -X POST https://api.dropboxapi.com/2/files/list_folder \
  --header "Authorization: Bearer ${bearer_token}" \
  --header 'Content-Type: application/json' \
  --data '{"path":"/workouts"}')
wo_paths=$(echo ${raw_workouts} | jq -r '.entries[]["path_display"]')

while read -r wo_path
do
filename=$(echo $wo_path | cut -d'/' -f3 | sed 's/\ /_/g')
 echo file: $filename
/usr/bin/curl -X POST https://content.dropboxapi.com/2/files/download \
  --header "Authorization: Bearer ${bearer_token}" \
  --header 'Dropbox-API-Arg: {"path":"'${wo_path}'"}' > $target_workout_dir/$filename
done < <(echo $wo_paths)

