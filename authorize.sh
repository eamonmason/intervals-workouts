#put URL in browser to get an offline/refresh token
#https://www.dropbox.com/oauth2/authorize?client_id=<app_key>&response_type=code&token_access_type=offline
curl https://api.dropbox.com/oauth2/token \
    -d code=<code from authorize URL>\
    -d grant_type=authorization_code \
    -d client_id=<app key> \
    -d client_secret=<app secret>
