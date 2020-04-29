#!/usr/bin/env zsh
#
#
#  Following instructions at https://developer.chrome.com/webstore/using_webstore_api
#
#

read -k 1 -r "reply?Did you run npm version? (y/N) "
if [[ "$reply" =~ "^[yY]$" ]]; then
else
  exit 0
fi

npm run create-zip

CLIENT_ID=763041075872-i11geq4kqqlorkhsm6blic1fg8skamaj.apps.googleusercontent.com

# Open this in the browser. Only works on Mac:

open "https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/chromewebstore&client_id=$CLIENT_ID&redirect_uri=urn:ietf:wg:oauth:2.0:oob"

# !!! This app isn't verified
echo
echo
read -r "CODE?What was the code? Paste and press enter: "
echo

# The CODE represents you having authorized Gobi to manage your Chrome Webstore on behalf of you.
# It's valid for only like 40 minutes at a time.

# CODE=4/zQEAM1..........8rK50yhzUXnFRypU1E

# cat client_secret_763041075872-i11geq4kqqlorkhsm6blic1fg8skamaj.apps.googleusercontent.com.json
# {
#   "installed": {
#     "client_id": "763041075872-i11geq4kqqlorkhsm6blic1fg8skamaj.apps.googleusercontent.com",
#     "project_id": "gobi-tron-production",
#     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
#     "token_uri": "https://oauth2.googleapis.com/token",
#     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs"
#   }
# }

# The tutorial says to include CLIENT_SECRET in the following request, but it's nowhere to be found,
# and not necessary either.

# Can only be run ONCE for each CODE
TOKEN=$(curl --silent "https://accounts.google.com/o/oauth2/token" -d "client_id=$CLIENT_ID&code=$CODE&grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob" | jq '.access_token' | xargs)
echo Access token is
echo TOKEN=$TOKEN
echo Now trying to upload your zip... but it might hang and never finish, for unknown reason...
# {
#   "access_token": "ya29.a0Ae4.......qhNQK-c",
#   "expires_in": 3599,
#   "scope": "https://www.googleapis.com/auth/chromewebstore",
#   "token_type": "Bearer"
# }

FILENAME=../GobiInsertStories.zip

APP_ID=fimchdpaiaeiflignlidhiabhnijcjki

curl -H "Authorization: Bearer $TOKEN" -H "x-goog-api-version: 2" -X PUT -T $FILENAME "https://www.googleapis.com/upload/chromewebstore/v1.1/items/$APP_ID"
