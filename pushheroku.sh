#twilio/pushheroku.sh
git add .
askdjfgdfw=$(date +%Y%m%d:%H-%M)
git commit -m $askdjfgdfw
git push heroku master
heroku restart
heroku ps
heroku open