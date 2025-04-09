cd ..
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/n-danh
git -C ./ANOMALY_API checkout develop
git -C ./ANOMALY_API pull
#git -C ./ANOMALY_WEB checkout develop
#git -C ./ANOMALY_WEB pull
sudo docker-compose run --rm -w /var/www/html/ANOMALY_API php composer install
sudo docker-compose run --rm -w /var/www/html/ANOMALY_API php php artisan optimize:clear
sudo docker-compose run --rm -w /var/www/html/ANOMALY_API php php artisan migrate
sudo docker-compose run --rm -w /var/www/html/ANOMALY_API supervisor php artisan queue:restart
sudo docker-compose run --rm -w /var/www/html/ANOMALY_API supervisor php artisan reverb:restart
#sudo docker-compose run --rm -w /var/www/html/ANOMALY_WEB npm install
#sudo docker-compose run --rm -w /var/www/html/ANOMALY_WEB npm run build
echo "S-NET System deployed"
